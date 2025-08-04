# Production environment example for hrafnar GCP deployment
module "hrafnar_prod" {
  source = "../../"

  # Core configuration
  project_id  = var.project_id
  region      = "us-central1"
  name_prefix = "prod-hrafnar"

  # Hrafnar application (production settings)
  app_image         = var.app_image
  app_min_instances = 2
  app_max_instances = 20
  app_cpu           = "2000m"
  app_memory        = "1Gi"

  # Production database settings
  database_tier                  = "db-standard-2"
  database_disk_size             = 100
  database_disk_autoresize_limit = 500
  database_backup_enabled        = true
  database_backup_retention_days = 30
  database_log_retention_days    = 30

  # AI configuration
  ai_api_keys = var.ai_api_keys

  # MCP servers (production endpoints)
  mcp_servers = var.mcp_servers

  # Network settings
  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidr  = "10.0.1.0/24"
  enable_nat_gateway   = true
  enable_vpc_connector = true

  # React frontend enabled for production
  enable_react_frontend = var.enable_react_frontend
  react_image           = var.react_image
  react_min_instances   = 1
  react_max_instances   = 10
  react_cpu             = "1000m"
  react_memory          = "512Mi"

  # HTMX frontend (can be disabled if using React)
  enable_htmx_frontend = var.enable_htmx_frontend

  # DNS configuration (typically enabled for production)
  enable_cloudflare_dns = var.enable_cloudflare_dns
  cloudflare_api_token  = var.cloudflare_api_token
  cloudflare_zone_id    = var.cloudflare_zone_id
  base_domain           = var.base_domain
  api_subdomain         = var.api_subdomain
  ui_subdomain          = var.ui_subdomain

  # Monitoring
  enable_monitoring = true
  log_level         = "INFO"

  # Security (more restrictive for production)
  allowed_ingress_cidrs = var.allowed_ingress_cidrs

  # Labels
  labels = {
    environment = "production"
    team        = "engineering"
    cost_center = "production"
    backup      = "required"
    monitoring  = "critical"
  }
}