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
| <a name="module_hrafnar_prod"></a> [hrafnar\_prod](#module\_hrafnar\_prod) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_api_keys"></a> [ai\_api\_keys](#input\_ai\_api\_keys) | Map of AI API keys (e.g., OPENAI\_API\_KEY, ANTHROPIC\_API\_KEY) | `map(string)` | n/a | yes |
| <a name="input_allowed_ingress_cidrs"></a> [allowed\_ingress\_cidrs](#input\_allowed\_ingress\_cidrs) | CIDR blocks allowed to access the applications | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_api_subdomain"></a> [api\_subdomain](#input\_api\_subdomain) | Subdomain for API access | `string` | `"api"` | no |
| <a name="input_app_image"></a> [app\_image](#input\_app\_image) | Container image for the hrafnar application | `string` | n/a | yes |
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base domain name (e.g., 'example.com') | `string` | n/a | yes |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API token | `string` | n/a | yes |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Cloudflare zone ID | `string` | n/a | yes |
| <a name="input_enable_cloudflare_dns"></a> [enable\_cloudflare\_dns](#input\_enable\_cloudflare\_dns) | Enable Cloudflare DNS management | `bool` | `true` | no |
| <a name="input_enable_htmx_frontend"></a> [enable\_htmx\_frontend](#input\_enable\_htmx\_frontend) | Enable built-in HTMX frontend | `bool` | `false` | no |
| <a name="input_enable_react_frontend"></a> [enable\_react\_frontend](#input\_enable\_react\_frontend) | Enable React frontend deployment | `bool` | `true` | no |
| <a name="input_mcp_servers"></a> [mcp\_servers](#input\_mcp\_servers) | MCP server configurations for production | <pre>map(object({<br/>    url         = string<br/>    api_key     = optional(string)<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID for production environment | `string` | n/a | yes |
| <a name="input_react_image"></a> [react\_image](#input\_react\_image) | Container image for the React frontend | `string` | `""` | no |
| <a name="input_ui_subdomain"></a> [ui\_subdomain](#input\_ui\_subdomain) | Subdomain for UI access | `string` | `"app"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_domain"></a> [api\_domain](#output\_api\_domain) | Production API domain |
| <a name="output_database_connection_name"></a> [database\_connection\_name](#output\_database\_connection\_name) | Production database connection name |
| <a name="output_hrafnar_app_service_account_email"></a> [hrafnar\_app\_service\_account\_email](#output\_hrafnar\_app\_service\_account\_email) | Service account email for hrafnar application |
| <a name="output_hrafnar_app_url"></a> [hrafnar\_app\_url](#output\_hrafnar\_app\_url) | URL of the hrafnar application in production |
| <a name="output_react_frontend_service_account_email"></a> [react\_frontend\_service\_account\_email](#output\_react\_frontend\_service\_account\_email) | Service account email for React frontend |
| <a name="output_react_frontend_url"></a> [react\_frontend\_url](#output\_react\_frontend\_url) | URL of the React frontend in production |
| <a name="output_ui_domain"></a> [ui\_domain](#output\_ui\_domain) | Production UI domain |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Production VPC network name |
<!-- END_TF_DOCS -->
