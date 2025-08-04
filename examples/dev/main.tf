# Development environment example for hrafner GCP deployment
module "hrafner_dev" {
  source = "../../"

  # Core configuration
  project_id  = var.project_id
  region      = "us-central1"
  name_prefix = "dev-hrafner"

  # Hrafner application
  app_image        = var.app_image
  app_min_instances = 0
  app_max_instances = 3
  app_cpu          = "500m"
  app_memory       = "256Mi"

  # Development database settings (smaller tier)
  database_tier                     = "db-f1-micro"
  database_disk_size               = 10
  database_disk_autoresize_limit   = 50
  database_backup_enabled          = false
  database_backup_retention_days   = 3
  database_log_retention_days      = 3

  # AI configuration
  ai_api_keys = var.ai_api_keys

  # MCP servers (development endpoints)
  mcp_servers = var.mcp_servers

  # Network settings
  vpc_cidr             = "10.1.0.0/16"
  private_subnet_cidr  = "10.1.1.0/24"
  enable_nat_gateway   = true
  enable_vpc_connector = true

  # Optional React frontend (disabled for dev to keep costs low)
  enable_react_frontend = false
  enable_htmx_frontend  = true

  # DNS (optional for development)
  enable_cloudflare_dns = var.enable_cloudflare_dns
  cloudflare_api_token  = var.cloudflare_api_token
  cloudflare_zone_id    = var.cloudflare_zone_id
  base_domain          = var.base_domain
  api_subdomain        = "dev-api"
  ui_subdomain         = "dev-app"

  # Monitoring
  enable_monitoring = true
  log_level        = "DEBUG"

  # Security (more permissive for development)
  allowed_ingress_cidrs = ["0.0.0.0/0"]

  # Labels
  labels = {
    environment = "development"
    team        = "engineering"
    cost_center = "development"
  }
}