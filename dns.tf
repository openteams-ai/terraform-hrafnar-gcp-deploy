# Data source to get the Cloudflare zone information
data "cloudflare_zone" "main" {
  count   = var.enable_cloudflare_dns ? 1 : 0
  zone_id = var.cloudflare_zone_id
}

# DNS A record for API subdomain pointing to hrafner application
resource "cloudflare_record" "api" {
  count   = var.enable_cloudflare_dns && var.base_domain != "" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = var.api_subdomain
  content = google_cloud_run_service.main_app.status[0].url
  type    = "CNAME"
  proxied = true

  comment = "Managed by Terraform - API endpoint for ${local.resource_prefix} hrafner application"

  depends_on = [google_cloud_run_domain_mapping.main_app]
}

# DNS A record for UI subdomain pointing to React frontend or hrafner application
resource "cloudflare_record" "ui" {
  count = var.enable_cloudflare_dns && var.base_domain != "" && (var.enable_react_frontend || var.enable_htmx_frontend) ? 1 : 0
  
  zone_id = var.cloudflare_zone_id
  name    = var.ui_subdomain
  content = var.enable_react_frontend ? google_cloud_run_service.react_frontend[0].status[0].url : google_cloud_run_service.main_app.status[0].url
  type    = "CNAME"
  proxied = true

  comment = var.enable_react_frontend ? "Managed by Terraform - UI endpoint for ${local.resource_prefix} React frontend" : "Managed by Terraform - UI endpoint for ${local.resource_prefix} hrafner HTMX frontend"

  depends_on = [
    google_cloud_run_domain_mapping.react_frontend,
    google_cloud_run_domain_mapping.ui_app
  ]
}