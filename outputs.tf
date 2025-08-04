# Hrafner Application Outputs
output "hrafner_app_url" {
  description = "URL of the hrafner application"
  value       = google_cloud_run_service.main_app.status[0].url
}

output "hrafner_app_service_name" {
  description = "Name of the hrafner Cloud Run service"
  value       = google_cloud_run_service.main_app.name
}

# React Frontend Outputs (if enabled)
output "react_frontend_url" {
  description = "URL of the React frontend (if enabled)"
  value       = var.enable_react_frontend ? google_cloud_run_service.react_frontend[0].status[0].url : null
}

output "react_frontend_service_name" {
  description = "Name of the React frontend Cloud Run service (if enabled)"
  value       = var.enable_react_frontend ? google_cloud_run_service.react_frontend[0].name : null
}

# DNS Outputs (if Cloudflare DNS is enabled)
output "api_domain" {
  description = "Full domain name for API access"
  value       = var.enable_cloudflare_dns && var.base_domain != "" ? local.api_fqdn : null
}

output "ui_domain" {
  description = "Full domain name for UI access"
  value       = var.enable_cloudflare_dns && var.base_domain != "" && (var.enable_react_frontend || var.enable_htmx_frontend) ? local.ui_fqdn : null
}

# Database Outputs
output "database_instance_name" {
  description = "Name of the Cloud SQL database instance"
  value       = google_sql_database_instance.main.name
}

output "database_connection_name" {
  description = "Connection name for the Cloud SQL database instance"
  value       = google_sql_database_instance.main.connection_name
}

output "database_private_ip" {
  description = "Private IP address of the Cloud SQL database instance"
  value       = google_sql_database_instance.main.private_ip_address
}

# Network Outputs
output "vpc_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.main.id
}

output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.main.name
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.private.id
}

output "private_subnet_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private.name
}

output "vpc_connector_id" {
  description = "ID of the VPC connector (if enabled)"
  value       = var.enable_vpc_connector ? google_vpc_access_connector.main[0].id : null
}

# Service Account Outputs
output "hrafner_app_service_account_email" {
  description = "Email of the hrafner application service account"
  value       = google_service_account.app.email
}

output "react_frontend_service_account_email" {
  description = "Email of the React frontend service account (if enabled)"
  value       = var.enable_react_frontend ? google_service_account.react[0].email : null
}

# Secret Manager Outputs
output "ai_api_key_secret_names" {
  description = "Names of the Secret Manager secrets for AI API keys"
  value       = { for k, v in local.ai_api_key_secrets : k => v }
}

output "database_password_secret_name" {
  description = "Name of the Secret Manager secret for database password"
  value       = google_secret_manager_secret.db_password.secret_id
}

output "database_connection_secret_name" {
  description = "Name of the Secret Manager secret for database connection string"
  value       = google_secret_manager_secret.db_connection.secret_id
}

# Resource Naming Outputs
output "resource_prefix" {
  description = "Prefix used for naming resources"
  value       = local.resource_prefix
}

output "common_labels" {
  description = "Common labels applied to all resources"
  value       = local.common_labels
}
