package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestDevEnvironmentDeployment tests actual deployment of the development environment
func TestDevEnvironmentDeployment(t *testing.T) {
	t.Parallel()

	// Generate a unique name prefix for this test run (lowercase only)
	uniqueID := strings.ToLower(random.UniqueId())
	namePrefix := fmt.Sprintf("test-dev-%s", uniqueID)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/dev",
		Vars: map[string]interface{}{
			// Required root/example variables to avoid "No value for required variable" errors
			"project_id":    "test-project",
			"region":        "us-central1",
			// Test-scoped variables
			"name_prefix":   namePrefix,
			"app_subdomain": namePrefix,
			"environment":   "integration-test",
			// Keep database disabled for this test to match assertions
			"enable_database": false,
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
	hrafnarAppURL := terraform.Output(t, terraformOptions, "hrafnar_app_url")
	assert.NotEmpty(t, hrafnarAppURL, "Hrafnar app URL should not be empty")
	assert.Contains(t, hrafnarAppURL, "run.app", "URL should be a Cloud Run URL")

	vpcName := terraform.Output(t, terraformOptions, "vpc_name")
	assert.NotEmpty(t, vpcName, "VPC name should not be empty")
	assert.Contains(t, vpcName, namePrefix, "VPC name should contain the name prefix")

	// Database should be disabled for this test, so database outputs should be empty
	databaseConnectionName := terraform.Output(t, terraformOptions, "database_connection_name")
	assert.Empty(t, databaseConnectionName, "Database connection name should be empty when database is disabled")
}
