
check "dns_configuration" {
  assert {
    condition     = !(var.base_domain != "" && var.app_subdomain != "" && !var.enable_cloudflare_dns)
    error_message = "Base domain and app subdomain are configured but enable_cloudflare_dns is false. DNS record will not be created."
  }
}

# DNS CNAME record for application subdomain pointing to Google Cloud Run
resource "cloudflare_record" "app" {
  count   = var.enable_cloudflare_dns && var.base_domain != "" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = var.app_subdomain
  content = "ghs.googlehosted.com"
  type    = "CNAME"
  proxied = false # Must be DNS-only initially for domain mapping to work

  comment = "Managed by Terraform - Application endpoint for ${local.resource_prefix} hrafnar application"

  depends_on = [google_cloud_run_domain_mapping.main_app]
}
