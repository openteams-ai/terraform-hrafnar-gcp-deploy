output "hrafner_app_url" {
  description = "URL of the hrafner application in development"
  value       = module.hrafner_dev.hrafner_app_url
}

output "api_domain" {
  description = "Development API domain (if DNS enabled)"
  value       = module.hrafner_dev.api_domain
}

output "ui_domain" {
  description = "Development UI domain (if DNS enabled)"
  value       = module.hrafner_dev.ui_domain
}

output "database_connection_name" {
  description = "Development database connection name"
  value       = module.hrafner_dev.database_connection_name
}

output "vpc_name" {
  description = "Development VPC network name"
  value       = module.hrafner_dev.vpc_name
}