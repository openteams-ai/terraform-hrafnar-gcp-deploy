package test

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestDevEnvironmentDeployment tests actual deployment of the development environment
func TestDevEnvironmentDeployment(t *testing.T) {
	t.Parallel()

	// Skip if required environment variables are not set
	projectID := os.Getenv("TF_VAR_project_id")
	if projectID == "" {
		t.Skip("Skipping integration test: TF_VAR_project_id not set")
	}

	// Generate a unique name prefix for this test run (lowercase only)
	uniqueID := strings.ToLower(random.UniqueId())
	namePrefix := fmt.Sprintf("test-dev-%s", uniqueID)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/dev",
		Vars: map[string]interface{}{
			"project_id":  projectID,
			"name_prefix": namePrefix,
			"app_image":   getEnvOrDefault("TF_VAR_app_image", "gcr.io/cloudrun/hello"),
			"ai_api_keys": map[string]string{
				"OPENAI_API_KEY": getEnvOrDefault("TF_VAR_openai_api_key", "sk-test-key-for-integration-testing"),
			},
		},
		// Retry configuration for handling transient errors
		RetryableTerraformErrors: map[string]string{
			".*Error creating Service.*": "Retry on Cloud Run service creation errors",
			".*Error waiting.*":          "Retry on resource waiting errors",
		},
		MaxRetries:         3,
		TimeBetweenRetries: 30,
	}

	// Clean up resources after test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply the configuration
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	hrafnerAppURL := terraform.Output(t, terraformOptions, "hrafner_app_url")
	assert.NotEmpty(t, hrafnerAppURL, "Hrafner app URL should not be empty")
	assert.Contains(t, hrafnerAppURL, "run.app", "URL should be a Cloud Run URL")

	vpcName := terraform.Output(t, terraformOptions, "vpc_name")
	assert.NotEmpty(t, vpcName, "VPC name should not be empty")
	assert.Contains(t, vpcName, namePrefix, "VPC name should contain the name prefix")

	databaseConnectionName := terraform.Output(t, terraformOptions, "database_connection_name")
	assert.NotEmpty(t, databaseConnectionName, "Database connection name should not be empty")
}

// TestProdEnvironmentDeployment tests actual deployment of the production environment
func TestProdEnvironmentDeployment(t *testing.T) {
	t.Parallel()

	// Skip if required environment variables are not set
	projectID := os.Getenv("TF_VAR_project_id")
	if projectID == "" {
		t.Skip("Skipping integration test: TF_VAR_project_id not set")
	}

	// Check if Cloudflare credentials are provided
	cloudflareAPIToken := os.Getenv("TF_VAR_cloudflare_api_token")
	cloudflareZoneID := os.Getenv("TF_VAR_cloudflare_zone_id")
	baseDomain := os.Getenv("TF_VAR_base_domain")
	enableCloudflare := cloudflareAPIToken != "" && cloudflareZoneID != "" && baseDomain != ""

	// Generate a unique name prefix for this test run (lowercase only)
	uniqueID := strings.ToLower(random.UniqueId())
	namePrefix := fmt.Sprintf("test-prod-%s", uniqueID)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/prod",
		Vars: map[string]interface{}{
			"project_id":             projectID,
			"name_prefix":            namePrefix,
			"app_image":              getEnvOrDefault("TF_VAR_app_image", "gcr.io/cloudrun/hello"),
			"enable_react_frontend":  false, // Disable React frontend for testing
			"enable_cloudflare_dns":  enableCloudflare,
			"cloudflare_api_token":   cloudflareAPIToken,
			"cloudflare_zone_id":     cloudflareZoneID,
			"base_domain":           baseDomain,
			"ai_api_keys": map[string]string{
				"OPENAI_API_KEY":    getEnvOrDefault("TF_VAR_openai_api_key", "sk-test-key-for-integration-testing"),
				"ANTHROPIC_API_KEY": getEnvOrDefault("TF_VAR_anthropic_api_key", "sk-ant-test-key-for-integration"),
			},
		},
		// Retry configuration for handling transient errors
		RetryableTerraformErrors: map[string]string{
			".*Error creating Service.*": "Retry on Cloud Run service creation errors",
			".*Error waiting.*":          "Retry on resource waiting errors",
		},
		MaxRetries:         3,
		TimeBetweenRetries: 30,
	}

	// Clean up resources after test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply the configuration
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	hrafnerAppURL := terraform.Output(t, terraformOptions, "hrafner_app_url")
	require.NotEmpty(t, hrafnerAppURL, "Hrafner app URL should not be empty")
	assert.Contains(t, hrafnerAppURL, "run.app", "URL should be a Cloud Run URL")

	vpcName := terraform.Output(t, terraformOptions, "vpc_name")
	assert.NotEmpty(t, vpcName, "VPC name should not be empty")
	assert.Contains(t, vpcName, namePrefix, "VPC name should contain the name prefix")

	databaseConnectionName := terraform.Output(t, terraformOptions, "database_connection_name")
	assert.NotEmpty(t, databaseConnectionName, "Database connection name should not be empty")

	// Check Cloudflare DNS outputs if enabled
	if enableCloudflare {
		apiDomain := terraform.Output(t, terraformOptions, "api_domain")
		assert.NotEmpty(t, apiDomain, "API domain should not be empty when Cloudflare is enabled")
		assert.Contains(t, apiDomain, baseDomain, "API domain should contain the base domain")

		uiDomain := terraform.Output(t, terraformOptions, "ui_domain")
		assert.NotEmpty(t, uiDomain, "UI domain should not be empty when Cloudflare is enabled")
		assert.Contains(t, uiDomain, baseDomain, "UI domain should contain the base domain")
	}
}

// Helper function to get environment variable with default value
func getEnvOrDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

// TestMinimalDeployment tests the absolute minimal configuration
func TestMinimalDeployment(t *testing.T) {
	// This test is NOT run in parallel to avoid resource conflicts
	
	// Skip if required environment variables are not set
	projectID := os.Getenv("TF_VAR_project_id")
	if projectID == "" {
		t.Skip("Skipping integration test: TF_VAR_project_id not set")
	}

	// Generate a unique name prefix for this test run (lowercase only)
	uniqueID := strings.ToLower(random.UniqueId())
	namePrefix := fmt.Sprintf("test-min-%s", uniqueID)

	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"project_id":  projectID,
			"name_prefix": namePrefix,
			"app_image":   getEnvOrDefault("TF_VAR_app_image", "gcr.io/cloudrun/hello"),
			// Minimal configuration - no AI keys, no Cloudflare, no React
			"enable_cloudflare_dns": false,
			"enable_react_frontend": false,
			"enable_htmx_frontend":  true,
			"database_tier":         "db-f1-micro",
			"database_disk_size":    10,
			"app_min_instances":     0,
			"app_max_instances":     2,
		},
		// Retry configuration for handling transient errors
		RetryableTerraformErrors: map[string]string{
			".*Error creating Service.*": "Retry on Cloud Run service creation errors",
			".*Error waiting.*":          "Retry on resource waiting errors",
		},
		MaxRetries:         3,
		TimeBetweenRetries: 30,
	}

	// Clean up resources after test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply the configuration
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	hrafnerAppURL := terraform.Output(t, terraformOptions, "hrafner_app_url")
	require.NotEmpty(t, hrafnerAppURL, "Hrafner app URL should not be empty")
	assert.Contains(t, hrafnerAppURL, "run.app", "URL should be a Cloud Run URL")

	// Ensure optional features are not deployed
	reactURL := terraform.Output(t, terraformOptions, "react_frontend_url")
	assert.Empty(t, reactURL, "React frontend URL should be empty when not enabled")

	apiDomain := terraform.Output(t, terraformOptions, "api_domain")
	assert.Empty(t, apiDomain, "API domain should be empty when Cloudflare is not enabled")
}