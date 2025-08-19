# Terraform GCP Hrafnar Deployment Module

A Terraform module for deploying the Hrafnar AI application on Google Cloud Platform with Cloud Run, Cloud SQL PostgreSQL, and optional Cloudflare DNS integration.

## Features

- 🚀 **Cloud Run Deployment**: Scalable serverless deployment for the Hrafnar application
- 🔐 **Secure Secret Management**: AI API keys and database credentials stored in Google Secret Manager
- 🗄️ **Managed PostgreSQL**: Cloud SQL PostgreSQL with automated backups and private networking
- 📡 **Cloudflare Integration**: Optional DNS management with automatic TLS certificates
- 🔧 **MCP Server Support**: Integration with Model Context Protocol servers
- 🛡️ **VPC Security**: Private networking with Cloud NAT for outbound connectivity
- 📊 **Monitoring Ready**: Built-in support for Google Cloud Monitoring and Logging

## Architecture

The module deploys:
- **Hrafnar Application**: Main Python/HTMX application on Cloud Run
- **PostgreSQL Database**: Private Cloud SQL instance with automated backups
- **VPC Network**: Private subnet with Cloud NAT for secure networking
- **Secret Manager**: Secure storage for API keys and database credentials
- **DNS Records** (optional): Cloudflare-managed DNS with automatic TLS

## Quick Start

### Basic Deployment

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
├── database.tf            # Cloud SQL PostgreSQL
├── dns.tf                 # Cloudflare DNS records
├── iam.tf                 # Service accounts and permissions
├── locals.tf              # Local values and computed resources
├── networking.tf          # VPC, subnets, and Cloud NAT
├── outputs.tf             # Module outputs
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
| [cloudflare_record.app](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [google_cloud_run_domain_mapping.main_app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping) | resource |
| [google_cloud_run_service.main_app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_member.main_app_public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) | resource |
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
| [google_project_service.required_apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_redis_instance.valkey](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance) | resource |
| [google_secret_manager_secret.ai_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.config_files](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.db_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.db_password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.mcp_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.storage_hmac_access_id](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.storage_hmac_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.valkey_auth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.valkey_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.app_ai_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_config_files](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_db_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_db_password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_mcp_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_storage_hmac_access_id](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_storage_hmac_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_valkey_auth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.app_valkey_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.ai_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.config_files](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.db_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.db_password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.mcp_api_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.storage_hmac_access_id](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.storage_hmac_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.valkey_auth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.valkey_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_sql_database.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [google_storage_bucket.hrafner_storage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.dev_storage_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.hrafner_app_storage_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_object.storage_folders](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [google_storage_hmac_key.hrafner_storage_hmac](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_hmac_key) | resource |
| [random_id.network_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_api_keys"></a> [ai\_api\_keys](#input\_ai\_api\_keys) | Map of AI API keys where key is the environment variable name (e.g., OPENAI\_API\_KEY, ANTHROPIC\_API\_KEY) and value is the actual API key (stored in Secret Manager) | `map(string)` | `{}` | no |
| <a name="input_app_command"></a> [app\_command](#input\_app\_command) | Command to run the container | `list(string)` | <pre>[<br/>  "hrafnar",<br/>  "serve"<br/>]</pre> | no |
| <a name="input_app_config_files"></a> [app\_config\_files](#input\_app\_config\_files) | Configuration files to mount as volumes from Secret Manager. Key is the config name, value contains file content and mount path. | <pre>map(object({<br/>    content    = string # File content to store in Secret Manager<br/>    mount_path = string # Path where file will be mounted in container (e.g., "/etc/config/app.yaml")<br/>  }))</pre> | `{}` | no |
| <a name="input_app_cpu"></a> [app\_cpu](#input\_app\_cpu) | CPU allocation for the hrafnar application | `string` | `"1000m"` | no |
| <a name="input_app_env_vars"></a> [app\_env\_vars](#input\_app\_env\_vars) | Environment variables for the hrafnar application | `map(string)` | `{}` | no |
| <a name="input_app_image"></a> [app\_image](#input\_app\_image) | Container image for the hrafnar application (without tag) | `string` | n/a | yes |
| <a name="input_app_image_sha"></a> [app\_image\_sha](#input\_app\_image\_sha) | Container image SHA (takes precedence over tag if provided) | `string` | `""` | no |
| <a name="input_app_image_tag"></a> [app\_image\_tag](#input\_app\_image\_tag) | Container image tag | `string` | `"latest"` | no |
| <a name="input_app_max_instances"></a> [app\_max\_instances](#input\_app\_max\_instances) | Maximum number of instances for the hrafnar application | `number` | `10` | no |
| <a name="input_app_memory"></a> [app\_memory](#input\_app\_memory) | Memory allocation for the hrafnar application | `string` | `"512Mi"` | no |
| <a name="input_app_min_instances"></a> [app\_min\_instances](#input\_app\_min\_instances) | Minimum number of instances for the hrafnar application | `number` | `0` | no |
| <a name="input_app_port"></a> [app\_port](#input\_app\_port) | Port the application listens on | `number` | `8080` | no |
| <a name="input_app_subdomain"></a> [app\_subdomain](#input\_app\_subdomain) | Subdomain for application access (e.g., 'app' for app.example.com) | `string` | `"app"` | no |
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base domain name managed by Cloudflare (e.g., 'example.com'). A subdomain will be created under this domain for application access | `string` | `""` | no |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Cloudflare zone ID for DNS records (required if enable\_cloudflare\_dns is true) | `string` | `""` | no |
| <a name="input_database_backup_enabled"></a> [database\_backup\_enabled](#input\_database\_backup\_enabled) | Enable automated database backups | `bool` | `true` | no |
| <a name="input_database_backup_retention_days"></a> [database\_backup\_retention\_days](#input\_database\_backup\_retention\_days) | Number of days to retain database backups | `number` | `7` | no |
| <a name="input_database_disk_autoresize_limit"></a> [database\_disk\_autoresize\_limit](#input\_database\_disk\_autoresize\_limit) | Maximum disk size in GB for database autoresize | `number` | `100` | no |
| <a name="input_database_disk_size"></a> [database\_disk\_size](#input\_database\_disk\_size) | Database disk size in GB | `number` | `20` | no |
| <a name="input_database_log_retention_days"></a> [database\_log\_retention\_days](#input\_database\_log\_retention\_days) | Number of days to retain database transaction logs | `number` | `7` | no |
| <a name="input_database_ssl_mode"></a> [database\_ssl\_mode](#input\_database\_ssl\_mode) | SSL mode for database connections | `string` | `"ENCRYPTED_ONLY"` | no |
| <a name="input_database_tier"></a> [database\_tier](#input\_database\_tier) | Database instance tier | `string` | `"db-f1-micro"` | no |
| <a name="input_enable_cloudflare_dns"></a> [enable\_cloudflare\_dns](#input\_enable\_cloudflare\_dns) | Enable Cloudflare DNS management | `bool` | `false` | no |
| <a name="input_enable_database"></a> [enable\_database](#input\_enable\_database) | Enable Cloud SQL database deployment | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable Google Cloud Monitoring and Logging | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable Cloud NAT for outbound internet access | `bool` | `true` | no |
| <a name="input_enable_storage"></a> [enable\_storage](#input\_enable\_storage) | Enable Cloud Storage bucket for the application | `bool` | `false` | no |
| <a name="input_enable_valkey"></a> [enable\_valkey](#input\_enable\_valkey) | Enable Google Cloud Memorystore for Redis (Valkey-compatible) deployment | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Log level for applications | `string` | `"INFO"` | no |
| <a name="input_mcp_servers"></a> [mcp\_servers](#input\_mcp\_servers) | MCP server configurations | <pre>map(object({<br/>    url         = string<br/>    api_key     = optional(string)<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource naming | `string` | n/a | yes |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | CIDR block for the private subnet | `string` | `"10.0.0.0/24"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where resources will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for resources | `string` | `"us-central1"` | no |
| <a name="input_storage_app_role"></a> [storage\_app\_role](#input\_storage\_app\_role) | IAM role for the application to access the storage bucket | `string` | `"roles/storage.objectAdmin"` | no |
| <a name="input_storage_cors_config"></a> [storage\_cors\_config](#input\_storage\_cors\_config) | CORS configuration for the storage bucket | <pre>list(object({<br/>    origin          = list(string)<br/>    method          = list(string)<br/>    response_header = list(string)<br/>    max_age_seconds = number<br/>  }))</pre> | <pre>[<br/>  {<br/>    "max_age_seconds": 3600,<br/>    "method": [<br/>      "GET",<br/>      "HEAD",<br/>      "PUT",<br/>      "POST",<br/>      "DELETE"<br/>    ],<br/>    "origin": [<br/>      "*"<br/>    ],<br/>    "response_header": [<br/>      "*"<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_storage_create_hmac_key"></a> [storage\_create\_hmac\_key](#input\_storage\_create\_hmac\_key) | Create HMAC key for S3-compatible access to the storage bucket | `bool` | `false` | no |
| <a name="input_storage_dev_access_members"></a> [storage\_dev\_access\_members](#input\_storage\_dev\_access\_members) | List of IAM members to grant development access to the storage bucket (e.g., 'user:dev@example.com') | `list(string)` | `[]` | no |
| <a name="input_storage_dev_role"></a> [storage\_dev\_role](#input\_storage\_dev\_role) | IAM role for development access to the storage bucket | `string` | `"roles/storage.objectAdmin"` | no |
| <a name="input_storage_enable_dev_access"></a> [storage\_enable\_dev\_access](#input\_storage\_enable\_dev\_access) | Enable external access to the storage bucket for development | `bool` | `false` | no |
| <a name="input_storage_folders"></a> [storage\_folders](#input\_storage\_folders) | List of folders to create in the storage bucket | `list(string)` | <pre>[<br/>  "files",<br/>  "thumbnails"<br/>]</pre> | no |
| <a name="input_storage_force_destroy"></a> [storage\_force\_destroy](#input\_storage\_force\_destroy) | Force destroy the storage bucket even if it contains objects | `bool` | `false` | no |
| <a name="input_storage_lifecycle_rules"></a> [storage\_lifecycle\_rules](#input\_storage\_lifecycle\_rules) | Lifecycle rules for the storage bucket | <pre>list(object({<br/>    condition = object({<br/>      age                   = optional(number)<br/>      num_newer_versions    = optional(number)<br/>      matches_prefix        = optional(list(string))<br/>      matches_storage_class = optional(list(string))<br/>    })<br/>    action = object({<br/>      type          = string<br/>      storage_class = optional(string)<br/>    })<br/>  }))</pre> | <pre>[<br/>  {<br/>    "action": {<br/>      "type": "Delete"<br/>    },<br/>    "condition": {<br/>      "age": 30,<br/>      "matches_prefix": [<br/>        "thumbnails/"<br/>      ]<br/>    }<br/>  },<br/>  {<br/>    "action": {<br/>      "type": "Delete"<br/>    },<br/>    "condition": {<br/>      "num_newer_versions": 5<br/>    }<br/>  }<br/>]</pre> | no |
| <a name="input_storage_public_access_prevention"></a> [storage\_public\_access\_prevention](#input\_storage\_public\_access\_prevention) | Public access prevention setting for the storage bucket | `string` | `"enforced"` | no |
| <a name="input_storage_versioning_enabled"></a> [storage\_versioning\_enabled](#input\_storage\_versioning\_enabled) | Enable versioning for the storage bucket | `bool` | `true` | no |
| <a name="input_valkey_auth_enabled"></a> [valkey\_auth\_enabled](#input\_valkey\_auth\_enabled) | Whether AUTH is enabled for the Redis instance | `bool` | `true` | no |
| <a name="input_valkey_maintenance_policy"></a> [valkey\_maintenance\_policy](#input\_valkey\_maintenance\_policy) | Maintenance policy for Redis instance | <pre>object({<br/>    weekly_maintenance_window = object({<br/>      day = string # MONDAY, TUESDAY, etc.<br/>      start_time = object({<br/>        hours   = number # 0-23<br/>        minutes = number # 0-59<br/>        seconds = number # 0-59<br/>        nanos   = number # 0-999999999<br/>      })<br/>    })<br/>  })</pre> | <pre>{<br/>  "weekly_maintenance_window": {<br/>    "day": "SUNDAY",<br/>    "start_time": {<br/>      "hours": 3,<br/>      "minutes": 0,<br/>      "nanos": 0,<br/>      "seconds": 0<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_valkey_memory_size_gb"></a> [valkey\_memory\_size\_gb](#input\_valkey\_memory\_size\_gb) | Redis instance memory size in GB | `number` | `1` | no |
| <a name="input_valkey_redis_configs"></a> [valkey\_redis\_configs](#input\_valkey\_redis\_configs) | Redis configuration parameters | `map(string)` | <pre>{<br/>  "maxmemory-policy": "allkeys-lru"<br/>}</pre> | no |
| <a name="input_valkey_redis_version"></a> [valkey\_redis\_version](#input\_valkey\_redis\_version) | Redis version for the instance | `string` | `"REDIS_7_0"` | no |
| <a name="input_valkey_tier"></a> [valkey\_tier](#input\_valkey\_tier) | Service tier of the Redis instance (BASIC or STANDARD\_HA) | `string` | `"BASIC"` | no |
| <a name="input_valkey_transit_encryption_mode"></a> [valkey\_transit\_encryption\_mode](#input\_valkey\_transit\_encryption\_mode) | TLS mode for Redis instance | `string` | `"SERVER_AUTHENTICATION"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ai_api_key_secret_names"></a> [ai\_api\_key\_secret\_names](#output\_ai\_api\_key\_secret\_names) | Names of the Secret Manager secrets for AI API keys |
| <a name="output_app_domain"></a> [app\_domain](#output\_app\_domain) | Full domain name for application access |
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
| <a name="output_resource_prefix"></a> [resource\_prefix](#output\_resource\_prefix) | Prefix used for naming resources |
| <a name="output_storage_bucket_name"></a> [storage\_bucket\_name](#output\_storage\_bucket\_name) | Name of the Cloud Storage bucket |
| <a name="output_storage_bucket_self_link"></a> [storage\_bucket\_self\_link](#output\_storage\_bucket\_self\_link) | Self link of the Cloud Storage bucket |
| <a name="output_storage_bucket_url"></a> [storage\_bucket\_url](#output\_storage\_bucket\_url) | URL of the Cloud Storage bucket |
| <a name="output_storage_hmac_access_id_secret_name"></a> [storage\_hmac\_access\_id\_secret\_name](#output\_storage\_hmac\_access\_id\_secret\_name) | Name of the Secret Manager secret containing the storage HMAC access ID |
| <a name="output_storage_hmac_secret_secret_name"></a> [storage\_hmac\_secret\_secret\_name](#output\_storage\_hmac\_secret\_secret\_name) | Name of the Secret Manager secret containing the storage HMAC secret key |
| <a name="output_valkey_auth_secret_name"></a> [valkey\_auth\_secret\_name](#output\_valkey\_auth\_secret\_name) | Name of the Secret Manager secret containing the Valkey auth string |
| <a name="output_valkey_connection_secret_name"></a> [valkey\_connection\_secret\_name](#output\_valkey\_connection\_secret\_name) | Name of the Secret Manager secret containing the Valkey connection URL |
| <a name="output_valkey_host"></a> [valkey\_host](#output\_valkey\_host) | Host IP of the Valkey/Redis instance |
| <a name="output_valkey_instance_name"></a> [valkey\_instance\_name](#output\_valkey\_instance\_name) | Name of the Valkey/Redis instance |
| <a name="output_valkey_memory_size_gb"></a> [valkey\_memory\_size\_gb](#output\_valkey\_memory\_size\_gb) | Memory size of the Valkey/Redis instance in GB |
| <a name="output_valkey_port"></a> [valkey\_port](#output\_valkey\_port) | Port of the Valkey/Redis instance |
| <a name="output_valkey_tier"></a> [valkey\_tier](#output\_valkey\_tier) | Service tier of the Valkey/Redis instance |
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
