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
  api_fqdn = var.enable_cloudflare_dns && var.base_domain != "" ? "${var.api_subdomain}.${var.base_domain}" : ""
  ui_fqdn  = var.enable_cloudflare_dns && var.base_domain != "" ? "${var.ui_subdomain}.${var.base_domain}" : ""

  # Determine which service should handle UI traffic
  ui_service_name = var.enable_react_frontend ? google_cloud_run_service.react_frontend[0].name : google_cloud_run_service.main_app.name

  # Database configuration
  database_name     = "${local.resource_prefix}-db"
  database_user     = "app_user"
  
  # Secret Manager secret names
  db_password_secret_name = "${local.resource_prefix}-db-password"
  ai_api_keys_secret_name = "${local.resource_prefix}-ai-api-keys"
  
  # Service account names
  app_service_account     = "${local.resource_prefix}-app"
  react_service_account   = "${local.resource_prefix}-react"
  
  # Network names
  vpc_name           = "${local.resource_prefix}-vpc"
  private_subnet_name = "${local.resource_prefix}-private-subnet"
  nat_gateway_name   = "${local.resource_prefix}-nat-gateway"
  router_name        = "${local.resource_prefix}-router"
  vpc_connector_name = "${local.resource_prefix}-vpc-connector"

  # Cloud Run service names
  main_app_service_name = "${local.resource_prefix}-app"
  react_service_name    = "${local.resource_prefix}-react"

  # Environment variables for the hrafner application
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
