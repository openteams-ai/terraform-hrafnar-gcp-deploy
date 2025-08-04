# Terraform GCP Hrafnar Deployment Module

A Terraform module for deploying the Hrafnar AI application on Google Cloud Platform with Cloud Run, Cloud SQL PostgreSQL, and optional Cloudflare DNS integration.

## Features

- 🚀 **Cloud Run Deployment**: Scalable serverless deployment for the Hrafnar application
- 🔐 **Secure Secret Management**: AI API keys and database credentials stored in Google Secret Manager
- 🗄️ **Managed PostgreSQL**: Cloud SQL PostgreSQL with automated backups and private networking
- 🌐 **Optional React Frontend**: Deploy a separate React-based UI alongside the main HTMX application
- 📡 **Cloudflare Integration**: Optional DNS management with automatic TLS certificates
- 🔧 **MCP Server Support**: Integration with Model Context Protocol servers
- 🛡️ **VPC Security**: Private networking with Cloud NAT for outbound connectivity
- 📊 **Monitoring Ready**: Built-in support for Google Cloud Monitoring and Logging

## Architecture

The module deploys:
- **Hrafnar Application**: Main Python/HTMX application on Cloud Run
- **React Frontend** (optional): Separate React UI on Cloud Run
- **PostgreSQL Database**: Private Cloud SQL instance with automated backups
- **VPC Network**: Private subnet with Cloud NAT for secure networking
- **Secret Manager**: Secure storage for API keys and database credentials
- **DNS Records** (optional): Cloudflare-managed DNS with automatic TLS

## Quick Start

### Basic Deployment (Hrafnar only)

```hcl
module "hrafnar_deploy" {
  source = "openteams-ai/hrafnar-gcp-deploy/gcp"

  project_id   = "my-gcp-project"
  name_prefix  = "prod-hrafnar"
  app_image    = "gcr.io/my-project/hrafnar:latest"
  
  ai_api_keys = {
    OPENAI_API_KEY = "sk-..."
  }
}
```

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── terraform.yml    # CI/CD pipeline
├── examples/               # Usage examples
│   ├── dev/               # Development environment
│   └── prod/              # Production environment
├── test/                  # Terratest suite
├── cloud-run.tf           # Hrafnar application deployment
├── cloud-run-react.tf     # Optional React frontend
├── database.tf            # Cloud SQL PostgreSQL
├── dns.tf                 # Cloudflare DNS records
├── iam.tf                 # Service accounts and permissions
├── locals.tf              # Local values and computed resources
├── networking.tf          # VPC, subnets, and Cloud NAT
├── outputs.tf             # Module outputs
├── providers.tf           # Provider configurations
├── secrets.tf             # Secret Manager configuration
├── variables.tf           # Input variables
├── versions.tf            # Provider version constraints
└── README.md             # This documentation
```

## Module Documentation

The following section contains auto-generated documentation for this Terraform module using terraform-docs:

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
module "cloudrun_ai_app" {
  source  = "openteams-ai/cloudrun-ai-app/gcp"
  version = "~> 1.0"

  project_id     = "my-gcp-project"
  region         = "us-central1"
  customer_name  = "acme-corp"
  domain_name    = "acme.example.com"

  # Application configuration
  app_image      = "gcr.io/my-project/ai-app:latest"
  app_env_vars   = {
    AI_BACKEND_URL = "https://api.openai.com/v1"
    MCP_SERVER_URL = "https://mcp.example.com"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Documentation Maintenance

This README uses terraform-docs to automatically generate and maintain module documentation. The content between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` is automatically generated.

### How to Update Documentation

1. **Auto-generate**: Run `make docs` to update the terraform-docs section
2. **Manual content**: Edit sections outside the terraform-docs markers
3. **Configuration**: Modify `.terraform-docs.yml` to customize the generated content

### terraform-docs Workflow

- The `make docs` command uses Docker to run terraform-docs
- It reads your Terraform files (main.tf, variables.tf, outputs.tf, etc.)
- Generates documentation in Markdown format
- Injects the content between the `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers
- Preserves all custom content outside these markers

**Important**: Never manually edit content between the terraform-docs markers as it will be overwritten.

## Examples

See the `examples/` directory for complete usage examples:

- **[Development](examples/dev/)**: Minimal configuration for development environments
- **[Production](examples/prod/)**: Full-featured production deployment with React frontend and Cloudflare DNS

## Security Considerations

- **Secret Management**: All sensitive data (API keys, database passwords) is stored in Google Secret Manager
- **Network Security**: Database runs in a private subnet with no public IP
- **Access Control**: Fine-grained IAM permissions for service accounts
- **TLS Encryption**: Database connections require TLS, Cloudflare provides automatic HTTPS

## Testing

The module includes comprehensive tests using Terratest:

### Test Coverage

1. **Hrafnar Module Functionality**: Tests variable validation and core functionality
2. **Cloudflare Integration**: Validates DNS configuration when enabled
3. **GCP Resources**: Tests Cloud Run, Cloud SQL, and networking components
4. **Configuration Scenarios**: Tests minimal and full-featured deployments

### Running Tests

#### Unit Tests (No Infrastructure)

```bash
# Run validation tests (no cloud resources)
cd test && go test -v -run TestTerraformValidation
cd test && go test -v -run TestExamplesValidation
cd test && go test -v -run TestHrafnarModuleFunctionality
```

#### Integration Tests (Real Infrastructure)

Integration tests deploy actual infrastructure to test end-to-end functionality.

**Required Environment Variables:**
```bash
export TF_VAR_project_id="your-gcp-project-id"
export TF_VAR_app_image="gcr.io/your-project/hrafnar:latest"
export TF_VAR_openai_api_key="sk-your-openai-key"

# Optional (for Cloudflare DNS testing):
export TF_VAR_cloudflare_api_token="your-cloudflare-token"
export TF_VAR_cloudflare_zone_id="your-zone-id"
export TF_VAR_base_domain="yourdomain.com"
```

**Run Integration Tests:**
```bash
# Test development environment deployment
cd test && go test -v -run TestDevEnvironmentDeployment -timeout 30m

# Test production environment deployment  
cd test && go test -v -run TestProdEnvironmentDeployment -timeout 30m

# Test minimal configuration
cd test && go test -v -run TestMinimalDeployment -timeout 30m

# Run all integration tests
cd test && go test -v -run Integration -timeout 45m
```

**Important Notes:**
- Integration tests will create and destroy real GCP resources
- Tests use unique prefixes to avoid naming conflicts
- Resources are automatically cleaned up after each test
- Ensure you have appropriate GCP permissions and billing enabled

## Makefile Commands

| Command       | Description                                      |
| ------------- | ------------------------------------------------ |
| `make help`   | Display available make targets with descriptions |
| `make init`   | Initialize OpenTofu and install pre-commit hooks |
| `make fmt`    | Format all Terraform files                      |
| `make validate` | Validate Terraform configuration              |
| `make lint`   | Run all linting checks                          |
| `make test`   | Run the full test suite                         |
| `make docs`   | Generate documentation with terraform-docs      |
| `make clean`  | Clean up temporary files and directories        |
