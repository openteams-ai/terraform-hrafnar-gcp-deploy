output "hrafnar_app_url" {
  description = "URL of the hrafnar application in development"
  value       = module.hrafnar_deploy.hrafnar_app_url
}

output "app_domain" {
  description = "Development app domain (if DNS enabled)"
  value       = module.hrafnar_deploy.app_domain
}

output "database_connection_name" {
  description = "Development database connection name"
  value       = module.hrafnar_deploy.database_connection_name
}

output "vpc_name" {
  description = "Development VPC network name"
  value       = module.hrafnar_deploy.vpc_name
}
