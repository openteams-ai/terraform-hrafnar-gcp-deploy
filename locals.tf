locals {
  # Resource naming
  resource_prefix = var.name_prefix

  # Common labels for all resources
  common_labels = merge(var.labels, {
    managed_by = "terraform"
    module     = "cloudrun-ai-app"
    project    = var.project_id
  })

  # DNS configuration
  app_fqdn = var.enable_cloudflare_dns && var.base_domain != "" ? "${var.app_subdomain}.${var.base_domain}" : ""


  # Database configuration
  database_name = "${local.resource_prefix}-db"
  database_user = "app_user"

  # Secret Manager secret names
  db_password_secret_name = "${local.resource_prefix}-db-password"

  # Service account names
  app_service_account = "${local.resource_prefix}-app"

  # Network names
  vpc_name            = "${local.resource_prefix}-vpc"
  private_subnet_name = "${local.resource_prefix}-private-subnet"
  nat_gateway_name    = "${local.resource_prefix}-nat-gateway"
  router_name         = "${local.resource_prefix}-router"
  # VPC connector name must be <= 25 chars and match ^[a-z][-a-z0-9]{0,23}[a-z0-9]$
  vpc_connector_name  = length("${local.resource_prefix}-connector") <= 25 ? "${local.resource_prefix}-connector" : "${substr(local.resource_prefix, 0, 15)}-connector"

  # Cloud Run service names
  main_app_service_name = "${local.resource_prefix}-app"

  # Environment variables for the hrafnar application
  app_environment_vars = merge(
    var.app_env_vars,
    {
      LOG_LEVEL  = var.log_level
      PROJECT_ID = var.project_id
      REGION     = var.region
    },
    # Add MCP server URLs if configured
    { for name, config in var.mcp_servers : "MCP_${upper(name)}_URL" => config.url }
  )

  # Secret Manager references for AI API keys
  ai_api_key_secrets = {
    for key_name in nonsensitive(keys(var.ai_api_keys)) :
    key_name => "${local.resource_prefix}-${lower(replace(key_name, "_", "-"))}"
  }

  # Secret Manager reference for database password
  db_connection_secret = "${local.resource_prefix}-db-connection"
}
