output "hrafnar_app_url" {
  description = "URL of the hrafnar application in development"
  value       = module.hrafnar_dev.hrafnar_app_url
}

output "api_domain" {
  description = "Development API domain (if DNS enabled)"
  value       = module.hrafnar_dev.api_domain
}

output "ui_domain" {
  description = "Development UI domain (if DNS enabled)"
  value       = module.hrafnar_dev.ui_domain
}

output "database_connection_name" {
  description = "Development database connection name"
  value       = module.hrafnar_dev.database_connection_name
}

output "vpc_name" {
  description = "Development VPC network name"
  value       = module.hrafnar_dev.vpc_name
}