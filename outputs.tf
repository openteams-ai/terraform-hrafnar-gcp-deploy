# Hrafnar Application Outputs
output "hrafnar_app_url" {
  description = "URL of the hrafnar application"
  value       = google_cloud_run_service.main_app.status[0].url
}

output "hrafnar_app_service_name" {
  description = "Name of the hrafnar Cloud Run service"
  value       = google_cloud_run_service.main_app.name
}


# DNS Outputs (if Cloudflare DNS is enabled)
output "app_domain" {
  description = "Full domain name for application access"
  value       = var.enable_cloudflare_dns && var.base_domain != "" ? local.app_fqdn : null
}

# Database Outputs (if database is enabled)
output "database_instance_name" {
  description = "Name of the Cloud SQL database instance"
  value       = var.enable_database ? google_sql_database_instance.main[0].name : null
}

output "database_connection_name" {
  description = "Connection name for the Cloud SQL database instance"
  value       = var.enable_database ? google_sql_database_instance.main[0].connection_name : null
}

output "database_private_ip" {
  description = "Private IP address of the Cloud SQL database instance"
  value       = var.enable_database ? google_sql_database_instance.main[0].private_ip_address : null
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
output "hrafnar_app_service_account_email" {
  description = "Email of the hrafnar application service account"
  value       = google_service_account.app.email
}


# Secret Manager Outputs
output "ai_api_key_secret_names" {
  description = "Names of the Secret Manager secrets for AI API keys"
  value       = { for k, v in local.ai_api_key_secrets : k => v }
}

output "database_password_secret_name" {
  description = "Name of the Secret Manager secret for database password"
  value       = var.enable_database ? google_secret_manager_secret.db_password[0].secret_id : null
}

output "database_connection_secret_name" {
  description = "Name of the Secret Manager secret for database connection string"
  value       = var.enable_database ? google_secret_manager_secret.db_connection[0].secret_id : null
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
