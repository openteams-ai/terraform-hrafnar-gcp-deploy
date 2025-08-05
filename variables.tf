# Core GCP Configuration
variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "Name prefix must contain only lowercase letters, numbers, and hyphens."
  }
}

# Networking Configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet (must be /28 for VPC connector compatibility)"
  type        = string
  default     = "10.0.1.0/28"
}

variable "enable_nat_gateway" {
  description = "Enable Cloud NAT for outbound internet access"
  type        = bool
  default     = true
}

# Database Configuration
variable "enable_database" {
  description = "Enable Cloud SQL database deployment"
  type        = bool
  default     = true
}

variable "database_tier" {
  description = "Database instance tier"
  type        = string
  default     = "db-f1-micro"
}

variable "database_disk_size" {
  description = "Database disk size in GB"
  type        = number
  default     = 20
}

variable "database_backup_enabled" {
  description = "Enable automated database backups"
  type        = bool
  default     = true
}

variable "database_disk_autoresize_limit" {
  description = "Maximum disk size in GB for database autoresize"
  type        = number
  default     = 100
}

variable "database_backup_retention_days" {
  description = "Number of days to retain database backups"
  type        = number
  default     = 7
}

variable "database_log_retention_days" {
  description = "Number of days to retain database transaction logs"
  type        = number
  default     = 7
}

# Application Configuration
variable "app_image" {
  description = "Container image for the hrafnar application"
  type        = string
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 8080
}

variable "app_cpu" {
  description = "CPU allocation for the hrafnar application"
  type        = string
  default     = "1000m"
}

variable "app_memory" {
  description = "Memory allocation for the hrafnar application"
  type        = string
  default     = "512Mi"
}

variable "app_min_instances" {
  description = "Minimum number of instances for the hrafnar application"
  type        = number
  default     = 0
}

variable "app_max_instances" {
  description = "Maximum number of instances for the hrafnar application"
  type        = number
  default     = 10
}

variable "app_env_vars" {
  description = "Environment variables for the hrafnar application"
  type        = map(string)
  default     = {}
}


# AI Backend Configuration
variable "ai_api_keys" {
  description = "Map of AI API keys where key is the environment variable name (e.g., OPENAI_API_KEY, ANTHROPIC_API_KEY) and value is the actual API key (stored in Secret Manager)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "mcp_servers" {
  description = "MCP server configurations"
  type = map(object({
    url         = string
    api_key     = optional(string)
    description = string
  }))
  default = {}
}


# DNS and TLS Configuration (Optional)
variable "enable_cloudflare_dns" {
  description = "Enable Cloudflare DNS management"
  type        = bool
  default     = false
}


variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for DNS records (required if enable_cloudflare_dns is true)"
  type        = string
  default     = ""
}

variable "base_domain" {
  description = "Base domain name managed by Cloudflare (e.g., 'example.com'). A subdomain will be created under this domain for application access"
  type        = string
  default     = ""
}

variable "app_subdomain" {
  description = "Subdomain for application access (e.g., 'app' for app.example.com)"
  type        = string
  default     = "app"
}

# Monitoring and Logging
variable "enable_monitoring" {
  description = "Enable Google Cloud Monitoring and Logging"
  type        = bool
  default     = true
}

variable "log_level" {
  description = "Log level for applications"
  type        = string
  default     = "INFO"
  validation {
    condition     = contains(["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], var.log_level)
    error_message = "Log level must be one of: DEBUG, INFO, WARNING, ERROR, CRITICAL."
  }
}

# Security Configuration

variable "enable_vpc_connector" {
  description = "Enable VPC Connector for Cloud Run to VPC communication"
  type        = bool
  default     = true
}

# Resource Tags
variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default     = {}
}
