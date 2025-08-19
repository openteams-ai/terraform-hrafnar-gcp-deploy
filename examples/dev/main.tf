# Development environment example for hrafnar GCP deployment

resource "random_password" "hrafnar_auth_password" {
  length  = 32
  special = true
}

# Store authentication password in Secret Manager
resource "google_secret_manager_secret" "hrafnar_auth_password" {
  secret_id = "${var.name_prefix}-hrafnar-auth-password"

  replication {
    auto {}
  }

  labels = {
    environment = var.environment
    project     = "test-${var.name_prefix}-openteams-ai"
    managed_by  = "terraform"
  }
}

resource "google_secret_manager_secret_version" "hrafnar_auth_password" {
  secret      = google_secret_manager_secret.hrafnar_auth_password.id
  secret_data = random_password.hrafnar_auth_password.result
}

module "hrafnar_deploy" {
  source = "../../"

  # Required variables
  project_id  = var.project_id
  name_prefix = var.name_prefix
  # For quay.io images, use Artifact Registry remote repository
  # See docs/ARTIFACT_REGISTRY_SETUP.md for one-time setup instructions
  app_image     = "${var.region}-docker.pkg.dev/${var.project_id}/quay-remote/reiemp/hrafnar"
  app_image_tag = "latest"

  # Production configuration
  region     = var.region
  app_port   = 8080
  app_cpu    = "1000m"
  app_memory = "1Gi"

  # Scaling configuration for production
  app_min_instances = 1
  app_max_instances = 1

  # Database configuration for production
  database_tier                  = "db-custom-2-4096" # 2 vCPUs, 4GB RAM
  database_disk_size             = 100
  database_backup_enabled        = true
  database_backup_retention_days = 30

  # AI API keys
  ai_api_keys = var.ai_api_keys

  # MCP server configuration
  mcp_servers = var.mcp_servers

  # Application environment variables
  app_env_vars = {
    HRAFNAR_SERVER_HOSTNAME                 = "0.0.0.0"
    HRAFNAR_SERVER_PORT                     = "8080"
    HRAFNAR_STORAGE_PERSISTENT_DATABASE_DSN = "sqlite:////var/hrafnar/state.db"
    HRAFNAR_AUTHENTICATION_METHOD = jsonencode({
      cls      = "hrafnar.serve.DummyBasicAuth"
      password = random_password.hrafnar_auth_password.result
    })
  }

  # Cloudflare DNS integration
  enable_cloudflare_dns = var.enable_cloudflare_dns
  cloudflare_zone_id    = var.cloudflare_zone_id
  base_domain           = var.base_domain
  app_subdomain         = var.app_subdomain

  # Infrastructure settings
  enable_database    = false
  enable_nat_gateway = true
  enable_monitoring  = true
  log_level          = "INFO"

  # Environment and labeling
  labels = {
    environment = var.environment
    project     = "test-${var.name_prefix}-openteams-ai"
    managed_by  = "terraform"
  }
}
