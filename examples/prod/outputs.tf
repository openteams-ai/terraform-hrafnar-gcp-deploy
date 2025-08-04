output "hrafner_app_url" {
  description = "URL of the hrafner application in production"
  value       = module.hrafner_prod.hrafner_app_url
}

output "react_frontend_url" {
  description = "URL of the React frontend in production"
  value       = module.hrafner_prod.react_frontend_url
}

output "api_domain" {
  description = "Production API domain"
  value       = module.hrafner_prod.api_domain
}

output "ui_domain" {
  description = "Production UI domain"
  value       = module.hrafner_prod.ui_domain
}

output "database_connection_name" {
  description = "Production database connection name"
  value       = module.hrafner_prod.database_connection_name
}

output "vpc_name" {
  description = "Production VPC network name"
  value       = module.hrafner_prod.vpc_name
}

output "hrafner_app_service_account_email" {
  description = "Service account email for hrafner application"
  value       = module.hrafner_prod.hrafner_app_service_account_email
}

output "react_frontend_service_account_email" {
  description = "Service account email for React frontend"
  value       = module.hrafner_prod.react_frontend_service_account_email
}