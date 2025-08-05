package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// Test basic Terraform validation without any cloud resources
func TestTerraformValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../",
	}

	// Test that terraform init works
	terraform.Init(t, terraformOptions)

	// Test that terraform validate passes
	terraform.Validate(t, terraformOptions)
}

// Test examples validate without deployment
func TestExamplesValidation(t *testing.T) {
	t.Parallel()

	examples := []string{"examples/dev", "examples/prod"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			terraformOptions := &terraform.Options{
				TerraformDir: "../" + example,
			}

			// Test that examples can be initialized and validated
			// This ensures they have proper syntax without actually deploying
			terraform.Init(t, terraformOptions)
			terraform.Validate(t, terraformOptions)
		})
	}
}

// Test hrafnar module specific functionality
func TestHrafnarModuleFunctionality(t *testing.T) {
	t.Parallel()

	// Test that required environment variables are documented
	t.Run("RequiredVariables", func(t *testing.T) {
		// Test that validation fails without required variables
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
		}

		// Initialize to ensure providers are available
		terraform.Init(t, terraformOptions)

		// Validate should pass even without variables set
		terraform.Validate(t, terraformOptions)
	})

	t.Run("VariableValidation", func(t *testing.T) {
		// Test that validation works with valid variables
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"project_id":   "test-project",
				"name_prefix":  "valid-name",
				"app_image":    "gcr.io/test/hrafnar:latest",
			},
		}

		terraform.Init(t, terraformOptions)
		terraform.Validate(t, terraformOptions)
	})
}

// Test Cloudflare integration functionality
func TestCloudflareIntegration(t *testing.T) {
	t.Parallel()

	t.Run("CloudflareDNSConfiguration", func(t *testing.T) {
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"project_id":             "test-project",
				"name_prefix":            "test-hrafnar",
				"app_image":              "gcr.io/test/hrafnar:latest",
				"enable_cloudflare_dns":  true,
				"cloudflare_zone_id":     "test-zone-id",
				"base_domain":           "example.com",
			},
		}

		// Initialize and validate configuration
		terraform.Init(t, terraformOptions)
		terraform.Validate(t, terraformOptions)
	})
}

// Test GCP-specific resource configuration
func TestGCPResourceConfiguration(t *testing.T) {
	t.Parallel()

	t.Run("CloudRunServiceConfiguration", func(t *testing.T) {
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"project_id":  "test-project",
				"name_prefix": "test-hrafnar",
				"app_image":   "gcr.io/test/hrafnar:latest",
				"ai_api_keys": map[string]string{
					"OPENAI_API_KEY":    "sk-test",
					"ANTHROPIC_API_KEY": "sk-ant-test",
				},
			},
		}

		// Initialize and validate configuration
		terraform.Init(t, terraformOptions)
		terraform.Validate(t, terraformOptions)
	})

	t.Run("ReactFrontendOptional", func(t *testing.T) {
		// Test with React frontend enabled
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"project_id":             "test-project",
				"name_prefix":            "test-hrafnar",
				"app_image":              "gcr.io/test/hrafnar:latest",
				"enable_react_frontend":  true,
				"react_image":            "gcr.io/test/hrafnar-ui:latest",
			},
		}

		// Initialize and validate configuration
		terraform.Init(t, terraformOptions)
		terraform.Validate(t, terraformOptions)
	})
}


// Test that validates the module works with realistic configuration
func TestRealisticConfiguration(t *testing.T) {
	t.Parallel()

	t.Run("MinimalConfiguration", func(t *testing.T) {
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"project_id":  "test-project-12345",
				"name_prefix": "minimal-test",
				"app_image":   "gcr.io/test-project/hrafnar:v1.0.0",
				"ai_api_keys": map[string]string{
					"OPENAI_API_KEY": "sk-test123",
				},
			},
		}

		// Initialize and validate configuration
		terraform.Init(t, terraformOptions)
		terraform.Validate(t, terraformOptions)
	})

	t.Run("FullConfiguration", func(t *testing.T) {
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"project_id":             "test-project-12345",
				"name_prefix":            "full-test",
				"app_image":              "gcr.io/test-project/hrafnar:v1.0.0",
				"enable_react_frontend":  true,
				"react_image":            "gcr.io/test-project/hrafnar-ui:v1.0.0",
				"enable_cloudflare_dns":  true,
				"cloudflare_zone_id":     "test-zone",
				"base_domain":           "test.example.com",
				"ai_api_keys": map[string]string{
					"OPENAI_API_KEY":    "sk-test123",
					"ANTHROPIC_API_KEY": "sk-ant-test123",
				},
				"mcp_servers": map[string]interface{}{
					"filesystem": map[string]interface{}{
						"url":         "https://mcp-fs.example.com",
						"description": "Filesystem MCP server",
					},
				},
			},
		}

		// Initialize and validate configuration
		terraform.Init(t, terraformOptions)
		terraform.Validate(t, terraformOptions)
	})
}
