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
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hrafnar_dev"></a> [hrafnar\_dev](#module\_hrafnar\_dev) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_api_keys"></a> [ai\_api\_keys](#input\_ai\_api\_keys) | Map of AI API keys (e.g., OPENAI\_API\_KEY, ANTHROPIC\_API\_KEY) | `map(string)` | `{}` | no |
| <a name="input_app_image"></a> [app\_image](#input\_app\_image) | Container image for the hrafnar application | `string` | `"gcr.io/my-project/hrafnar:dev"` | no |
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base domain name (e.g., 'example.com') | `string` | `""` | no |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API token (required if enable\_cloudflare\_dns is true) | `string` | `""` | no |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Cloudflare zone ID (required if enable\_cloudflare\_dns is true) | `string` | `""` | no |
| <a name="input_enable_cloudflare_dns"></a> [enable\_cloudflare\_dns](#input\_enable\_cloudflare\_dns) | Enable Cloudflare DNS management for development | `bool` | `false` | no |
| <a name="input_mcp_servers"></a> [mcp\_servers](#input\_mcp\_servers) | MCP server configurations for development | <pre>map(object({<br/>    url         = string<br/>    api_key     = optional(string)<br/>    description = string<br/>  }))</pre> | <pre>{<br/>  "filesystem": {<br/>    "description": "Local filesystem MCP server for development",<br/>    "url": "http://localhost:3001"<br/>  }<br/>}</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID for development environment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_domain"></a> [api\_domain](#output\_api\_domain) | Development API domain (if DNS enabled) |
| <a name="output_database_connection_name"></a> [database\_connection\_name](#output\_database\_connection\_name) | Development database connection name |
| <a name="output_hrafnar_app_url"></a> [hrafnar\_app\_url](#output\_hrafnar\_app\_url) | URL of the hrafnar application in development |
| <a name="output_ui_domain"></a> [ui\_domain](#output\_ui\_domain) | Development UI domain (if DNS enabled) |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Development VPC network name |
<!-- END_TF_DOCS -->
