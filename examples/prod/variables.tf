variable "project_id" {
  description = "GCP project ID for production environment"
  type        = string
}

variable "app_image" {
  description = "Container image for the hrafnar application"
  type        = string
}

variable "ai_api_keys" {
  description = "Map of AI API keys (e.g., OPENAI_API_KEY, ANTHROPIC_API_KEY)"
  type        = map(string)
  sensitive   = true
}

variable "mcp_servers" {
  description = "MCP server configurations for production"
  type = map(object({
    url         = string
    api_key     = optional(string)
    description = string
  }))
  default = {}
}

# React frontend configuration
variable "enable_react_frontend" {
  description = "Enable React frontend deployment"
  type        = bool
  default     = true
}

variable "react_image" {
  description = "Container image for the React frontend"
  type        = string
  default     = ""
}

variable "enable_htmx_frontend" {
  description = "Enable built-in HTMX frontend"
  type        = bool
  default     = false
}

# Cloudflare DNS configuration
variable "enable_cloudflare_dns" {
  description = "Enable Cloudflare DNS management"
  type        = bool
  default     = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "base_domain" {
  description = "Base domain name (e.g., 'example.com')"
  type        = string
}

variable "api_subdomain" {
  description = "Subdomain for API access"
  type        = string
  default     = "api"
}

variable "ui_subdomain" {
  description = "Subdomain for UI access"
  type        = string
  default     = "app"
}

# Security configuration
