variable "project_id" {
  description = "GCP project ID for development environment"
  type        = string
}

variable "app_image" {
  description = "Container image for the hrafnar application"
  type        = string
  default     = "gcr.io/my-project/hrafnar:dev"
}

variable "ai_api_keys" {
  description = "Map of AI API keys (e.g., OPENAI_API_KEY, ANTHROPIC_API_KEY)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "mcp_servers" {
  description = "MCP server configurations for development"
  type = map(object({
    url         = string
    api_key     = optional(string)
    description = string
  }))
  default = {
    filesystem = {
      url         = "http://localhost:3001"
      description = "Local filesystem MCP server for development"
    }
  }
}

# Optional Cloudflare DNS configuration
variable "enable_cloudflare_dns" {
  description = "Enable Cloudflare DNS management for development"
  type        = bool
  default     = false
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token (required if enable_cloudflare_dns is true)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID (required if enable_cloudflare_dns is true)"
  type        = string
  default     = ""
}

variable "base_domain" {
  description = "Base domain name (e.g., 'example.com')"
  type        = string
  default     = ""
}