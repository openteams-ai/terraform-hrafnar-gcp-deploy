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

### Basic Usage (hrafnar app only)

```hcl
module "hrafnar_gcp_deploy" {
  source  = "openteams-ai/hrafnar-gcp-deploy/gcp"
  version = "~> 1.0"

  project_id   = "my-gcp-project"
  region       = "us-central1" 
  name_prefix  = "acme-hrafnar"

  # Hrafnar application configuration
  app_image = "gcr.io/my-project/hrafnar:latest"
  
  # AI API keys (stored securely in Secret Manager)
  ai_api_keys = {
    OPENAI_API_KEY    = "sk-..."
    ANTHROPIC_API_KEY = "sk-ant-..."
  }
}
```

### With Cloudflare DNS and React Frontend

```hcl
module "hrafnar_gcp_deploy" {
  source  = "openteams-ai/hrafnar-gcp-deploy/gcp"
  version = "~> 1.0"

  project_id   = "my-gcp-project"
  region       = "us-central1"
  name_prefix  = "acme-hrafnar"

  # Hrafnar application
  app_image = "gcr.io/my-project/hrafnar:latest"
  
  # Optional React frontend
  enable_react_frontend = true
  react_image          = "gcr.io/my-project/hrafnar-ui:latest"

  # Cloudflare DNS configuration
  enable_cloudflare_dns = true
  cloudflare_api_token  = "your-cloudflare-token"
  cloudflare_zone_id    = "your-zone-id"
  base_domain          = "example.com"
  api_subdomain        = "api"
  ui_subdomain         = "app"

  # AI configuration
  ai_api_keys = {
    OPENAI_API_KEY    = "sk-..."
    ANTHROPIC_API_KEY = "sk-ant-..."
  }

  # MCP servers
  mcp_servers = {
    filesystem = {
      url         = "https://mcp-fs.example.com"
      description = "Filesystem MCP server"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.52.1 |
| <a name="provider_google"></a> [google](#provider\_google) | 5.45.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.api](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.ui](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [google_cloud_run_domain_mapping.main_app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping) | resource |
| [google_cloud_run_domain_mapping.react_frontend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping) | resource |
| [google_cloud_run_domain_mapping.ui_app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping) | resource |
| [google_cloud_run_service.main_app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service.react_frontend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_member.main_app_public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) | resource |
| [google_cloud_run_service_iam_member.react_frontend_public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) | resource |
| [google_compute_firewall.allow_health_checks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.private_ip_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_network.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.private](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_project_iam_member.app_cloudsql_client](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.app_cloudsql_instanceuser](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.app_logging_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.app_monitoring_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.react_logging_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.react_monitoring_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.required_apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_secret_manager_secret.ai_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.db_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.db_password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.mcp_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.app_ai_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_db_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_db_password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_mcp_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.ai_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.db_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.db_password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.mcp_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.react](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_sql_database.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [google_vpc_access_connector.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vpc_access_connector) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_api_keys"></a> [ai\_api\_keys](#input\_ai\_api\_keys) | Map of AI API keys where key is the environment variable name (e.g., OPENAI\_API\_KEY, ANTHROPIC\_API\_KEY) and value is the actual API key (stored in Secret Manager) | `map(string)` | `{}` | no |
| <a name="input_api_subdomain"></a> [api\_subdomain](#input\_api\_subdomain) | Subdomain for API access (e.g., 'api' for api.example.com) | `string` | `"api"` | no |
| <a name="input_app_cpu"></a> [app\_cpu](#input\_app\_cpu) | CPU allocation for the hrafnar application | `string` | `"1000m"` | no |
| <a name="input_app_env_vars"></a> [app\_env\_vars](#input\_app\_env\_vars) | Environment variables for the hrafnar application | `map(string)` | `{}` | no |
| <a name="input_app_image"></a> [app\_image](#input\_app\_image) | Container image for the hrafnar application | `string` | n/a | yes |
| <a name="input_app_max_instances"></a> [app\_max\_instances](#input\_app\_max\_instances) | Maximum number of instances for the hrafnar application | `number` | `10` | no |
| <a name="input_app_memory"></a> [app\_memory](#input\_app\_memory) | Memory allocation for the hrafnar application | `string` | `"512Mi"` | no |
| <a name="input_app_min_instances"></a> [app\_min\_instances](#input\_app\_min\_instances) | Minimum number of instances for the hrafnar application | `number` | `0` | no |
| <a name="input_app_port"></a> [app\_port](#input\_app\_port) | Port the application listens on | `number` | `8080` | no |
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base domain name managed by Cloudflare (e.g., 'example.com'). Subdomains will be created under this domain for API and UI access | `string` | `""` | no |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API token for DNS management (required if enable\_cloudflare\_dns is true) | `string` | `""` | no |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Cloudflare zone ID for DNS records (required if enable\_cloudflare\_dns is true) | `string` | `""` | no |
| <a name="input_database_backup_enabled"></a> [database\_backup\_enabled](#input\_database\_backup\_enabled) | Enable automated database backups | `bool` | `true` | no |
| <a name="input_database_backup_retention_days"></a> [database\_backup\_retention\_days](#input\_database\_backup\_retention\_days) | Number of days to retain database backups | `number` | `7` | no |
| <a name="input_database_disk_autoresize_limit"></a> [database\_disk\_autoresize\_limit](#input\_database\_disk\_autoresize\_limit) | Maximum disk size in GB for database autoresize | `number` | `100` | no |
| <a name="input_database_disk_size"></a> [database\_disk\_size](#input\_database\_disk\_size) | Database disk size in GB | `number` | `20` | no |
| <a name="input_database_log_retention_days"></a> [database\_log\_retention\_days](#input\_database\_log\_retention\_days) | Number of days to retain database transaction logs | `number` | `7` | no |
| <a name="input_database_tier"></a> [database\_tier](#input\_database\_tier) | Database instance tier | `string` | `"db-f1-micro"` | no |
| <a name="input_enable_cloudflare_dns"></a> [enable\_cloudflare\_dns](#input\_enable\_cloudflare\_dns) | Enable Cloudflare DNS management | `bool` | `false` | no |
| <a name="input_enable_htmx_frontend"></a> [enable\_htmx\_frontend](#input\_enable\_htmx\_frontend) | Enable built-in HTMX frontend in the hrafnar application | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable Google Cloud Monitoring and Logging | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable Cloud NAT for outbound internet access | `bool` | `true` | no |
| <a name="input_enable_react_frontend"></a> [enable\_react\_frontend](#input\_enable\_react\_frontend) | Enable optional React frontend deployment | `bool` | `false` | no |
| <a name="input_enable_vpc_connector"></a> [enable\_vpc\_connector](#input\_enable\_vpc\_connector) | Enable VPC Connector for Cloud Run to VPC communication | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Log level for applications | `string` | `"INFO"` | no |
| <a name="input_mcp_servers"></a> [mcp\_servers](#input\_mcp\_servers) | MCP server configurations | <pre>map(object({<br/>    url         = string<br/>    api_key     = optional(string)<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource naming | `string` | n/a | yes |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | CIDR block for the private subnet | `string` | `"10.0.1.0/24"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where resources will be created | `string` | n/a | yes |
| <a name="input_react_cpu"></a> [react\_cpu](#input\_react\_cpu) | CPU allocation for the React frontend | `string` | `"500m"` | no |
| <a name="input_react_image"></a> [react\_image](#input\_react\_image) | Container image for the React frontend (if enabled) | `string` | `""` | no |
| <a name="input_react_max_instances"></a> [react\_max\_instances](#input\_react\_max\_instances) | Maximum number of instances for the React frontend | `number` | `5` | no |
| <a name="input_react_memory"></a> [react\_memory](#input\_react\_memory) | Memory allocation for the React frontend | `string` | `"256Mi"` | no |
| <a name="input_react_min_instances"></a> [react\_min\_instances](#input\_react\_min\_instances) | Minimum number of instances for the React frontend | `number` | `0` | no |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for resources | `string` | `"us-central1"` | no |
| <a name="input_ui_subdomain"></a> [ui\_subdomain](#input\_ui\_subdomain) | Subdomain for UI access (e.g., 'app' for app.example.com). Points to React frontend if enabled, otherwise to HTMX frontend | `string` | `"app"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ai_api_key_secret_names"></a> [ai\_api\_key\_secret\_names](#output\_ai\_api\_key\_secret\_names) | Names of the Secret Manager secrets for AI API keys |
| <a name="output_api_domain"></a> [api\_domain](#output\_api\_domain) | Full domain name for API access |
| <a name="output_common_labels"></a> [common\_labels](#output\_common\_labels) | Common labels applied to all resources |
| <a name="output_database_connection_name"></a> [database\_connection\_name](#output\_database\_connection\_name) | Connection name for the Cloud SQL database instance |
| <a name="output_database_connection_secret_name"></a> [database\_connection\_secret\_name](#output\_database\_connection\_secret\_name) | Name of the Secret Manager secret for database connection string |
| <a name="output_database_instance_name"></a> [database\_instance\_name](#output\_database\_instance\_name) | Name of the Cloud SQL database instance |
| <a name="output_database_password_secret_name"></a> [database\_password\_secret\_name](#output\_database\_password\_secret\_name) | Name of the Secret Manager secret for database password |
| <a name="output_database_private_ip"></a> [database\_private\_ip](#output\_database\_private\_ip) | Private IP address of the Cloud SQL database instance |
| <a name="output_hrafnar_app_service_account_email"></a> [hrafnar\_app\_service\_account\_email](#output\_hrafnar\_app\_service\_account\_email) | Email of the hrafnar application service account |
| <a name="output_hrafnar_app_service_name"></a> [hrafnar\_app\_service\_name](#output\_hrafnar\_app\_service\_name) | Name of the hrafnar Cloud Run service |
| <a name="output_hrafnar_app_url"></a> [hrafnar\_app\_url](#output\_hrafnar\_app\_url) | URL of the hrafnar application |
| <a name="output_private_subnet_id"></a> [private\_subnet\_id](#output\_private\_subnet\_id) | ID of the private subnet |
| <a name="output_private_subnet_name"></a> [private\_subnet\_name](#output\_private\_subnet\_name) | Name of the private subnet |
| <a name="output_react_frontend_service_account_email"></a> [react\_frontend\_service\_account\_email](#output\_react\_frontend\_service\_account\_email) | Email of the React frontend service account (if enabled) |
| <a name="output_react_frontend_service_name"></a> [react\_frontend\_service\_name](#output\_react\_frontend\_service\_name) | Name of the React frontend Cloud Run service (if enabled) |
| <a name="output_react_frontend_url"></a> [react\_frontend\_url](#output\_react\_frontend\_url) | URL of the React frontend (if enabled) |
| <a name="output_resource_prefix"></a> [resource\_prefix](#output\_resource\_prefix) | Prefix used for naming resources |
| <a name="output_ui_domain"></a> [ui\_domain](#output\_ui\_domain) | Full domain name for UI access |
| <a name="output_vpc_connector_id"></a> [vpc\_connector\_id](#output\_vpc\_connector\_id) | ID of the VPC connector (if enabled) |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC network |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Name of the VPC network |
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
