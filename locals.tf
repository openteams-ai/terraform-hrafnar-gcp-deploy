# Random suffix for network resources to avoid naming collisions
resource "random_id" "network_suffix" {
  byte_length = 4
}

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

  # Network names with random suffix to avoid naming collisions
  vpc_name            = "${local.resource_prefix}-vpc-${random_id.network_suffix.hex}"
  private_subnet_name = "${local.resource_prefix}-subnet-${random_id.network_suffix.hex}"
  nat_gateway_name    = "${local.resource_prefix}-nat-${random_id.network_suffix.hex}"
  router_name         = "${local.resource_prefix}-router-${random_id.network_suffix.hex}"

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
    { for name, config in var.mcp_servers : "MCP_${upper(name)}_URL" => config.url },
    # Add storage bucket name if enabled
    var.enable_storage ? {
      STORAGE_BUCKET_NAME = google_storage_bucket.hrafner_storage[0].name
      GCS_BUCKET_NAME     = google_storage_bucket.hrafner_storage[0].name # Alternative env var name
    } : {}
  )

  # Secret Manager references for AI API keys
  ai_api_key_secrets = {
    for key_name in nonsensitive(keys(var.ai_api_keys)) :
    key_name => "${local.resource_prefix}-${lower(replace(key_name, "_", "-"))}"
  }

  # Secret Manager reference for database password
  db_connection_secret = "${local.resource_prefix}-db-connection"

  # Valkey/Redis configuration
  valkey_instance_name     = "${local.resource_prefix}-valkey"
  valkey_connection_secret = "${local.resource_prefix}-valkey-connection"
  valkey_auth_secret       = "${local.resource_prefix}-valkey-auth"

  # Valkey connection string format
  valkey_connection_string = var.enable_valkey ? (
    var.valkey_auth_enabled ?
    "valkey://default:${google_redis_instance.valkey[0].auth_string}@${google_redis_instance.valkey[0].host}:${google_redis_instance.valkey[0].port}" :
    "valkey://${google_redis_instance.valkey[0].host}:${google_redis_instance.valkey[0].port}"
  ) : ""
}
