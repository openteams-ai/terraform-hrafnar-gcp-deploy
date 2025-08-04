output "hrafnar_app_url" {
  description = "URL of the hrafnar application in production"
  value       = module.hrafnar_prod.hrafnar_app_url
}

output "react_frontend_url" {
  description = "URL of the React frontend in production"
  value       = module.hrafnar_prod.react_frontend_url
}

output "api_domain" {
  description = "Production API domain"
  value       = module.hrafnar_prod.api_domain
}

output "ui_domain" {
  description = "Production UI domain"
  value       = module.hrafnar_prod.ui_domain
}

output "database_connection_name" {
  description = "Production database connection name"
  value       = module.hrafnar_prod.database_connection_name
}

output "vpc_name" {
  description = "Production VPC network name"
  value       = module.hrafnar_prod.vpc_name
}

output "hrafnar_app_service_account_email" {
  description = "Service account email for hrafnar application"
  value       = module.hrafnar_prod.hrafnar_app_service_account_email
}

output "react_frontend_service_account_email" {
  description = "Service account email for React frontend"
  value       = module.hrafnar_prod.react_frontend_service_account_email
}
