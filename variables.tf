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
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.0.0/24"
  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2}$", var.private_subnet_cidr))
    error_message = "Invalid CIDR format."
  }

  # Ensure CIDR is /26 or larger (See https://cloud.google.com/run/docs/configuring/vpc-direct-vpc#scale_down for more info)
  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2}$", var.private_subnet_cidr)) && (tonumber(regex("[0-9]{1,2}$", var.private_subnet_cidr)) <= 26)
    error_message = "CIDR range must be /26 or larger (required by direct VPC egress)."
  }
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

variable "database_ssl_mode" {
  description = "SSL mode for database connections"
  type        = string
  default     = "ENCRYPTED_ONLY"
  validation {
    condition     = contains(["ALLOW_UNENCRYPTED_AND_ENCRYPTED", "ENCRYPTED_ONLY", "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"], var.database_ssl_mode)
    error_message = "SSL mode must be one of: ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, TRUSTED_CLIENT_CERTIFICATE_REQUIRED."
  }
}

# Valkey/Redis Configuration
variable "enable_valkey" {
  description = "Enable Google Cloud Memorystore for Redis (Valkey-compatible) deployment"
  type        = bool
  default     = false
}

variable "valkey_memory_size_gb" {
  description = "Redis instance memory size in GB"
  type        = number
  default     = 1
}

variable "valkey_tier" {
  description = "Service tier of the Redis instance (BASIC or STANDARD_HA)"
  type        = string
  default     = "BASIC"
  validation {
    condition     = contains(["BASIC", "STANDARD_HA"], var.valkey_tier)
    error_message = "Valkey tier must be either BASIC or STANDARD_HA."
  }
}

variable "valkey_redis_version" {
  description = "Redis version for the instance"
  type        = string
  default     = "REDIS_7_0"
  validation {
    condition     = contains(["REDIS_6_X", "REDIS_7_0"], var.valkey_redis_version)
    error_message = "Redis version must be either REDIS_6_X or REDIS_7_0."
  }
}

variable "valkey_auth_enabled" {
  description = "Whether AUTH is enabled for the Redis instance"
  type        = bool
  default     = true
}

variable "valkey_transit_encryption_mode" {
  description = "TLS mode for Redis instance"
  type        = string
  default     = "SERVER_AUTHENTICATION"
  validation {
    condition     = contains(["DISABLED", "SERVER_AUTHENTICATION"], var.valkey_transit_encryption_mode)
    error_message = "Transit encryption mode must be either DISABLED or SERVER_AUTH."
  }
}

variable "valkey_redis_configs" {
  description = "Redis configuration parameters"
  type        = map(string)
  default = {
    maxmemory-policy = "allkeys-lru"
  }
}

variable "valkey_maintenance_policy" {
  description = "Maintenance policy for Redis instance"
  type = object({
    weekly_maintenance_window = object({
      day = string # MONDAY, TUESDAY, etc.
      start_time = object({
        hours   = number # 0-23
        minutes = number # 0-59
        seconds = number # 0-59
        nanos   = number # 0-999999999
      })
    })
  })
  default = {
    weekly_maintenance_window = {
      day = "SUNDAY"
      start_time = {
        hours   = 3
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }
  }
}

# Application Configuration
variable "app_image" {
  description = "Container image for the hrafnar application (without tag)"
  type        = string
}

variable "app_image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

variable "app_image_sha" {
  description = "Container image SHA (takes precedence over tag if provided)"
  type        = string
  default     = ""
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 8080
}

variable "app_command" {
  description = "Command to run the container"
  type        = list(string)
  default     = ["hrafnar", "serve"]
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

variable "app_config_files" {
  description = "Configuration files to mount as volumes from Secret Manager. Key is the config name, value contains file content and mount path."
  type = map(object({
    content    = string # File content to store in Secret Manager
    mount_path = string # Path where file will be mounted in container (e.g., "/etc/config/app.yaml")
  }))
  default = {}
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


# Storage Configuration
variable "enable_storage" {
  description = "Enable Cloud Storage bucket for the application"
  type        = bool
  default     = false
}

variable "storage_force_destroy" {
  description = "Force destroy the storage bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "storage_versioning_enabled" {
  description = "Enable versioning for the storage bucket"
  type        = bool
  default     = true
}

variable "storage_folders" {
  description = "List of folders to create in the storage bucket"
  type        = list(string)
  default     = ["files", "thumbnails"]
}

variable "storage_public_access_prevention" {
  description = "Public access prevention setting for the storage bucket"
  type        = string
  default     = "enforced"
  validation {
    condition     = contains(["inherited", "enforced"], var.storage_public_access_prevention)
    error_message = "Public access prevention must be either 'inherited' or 'enforced'."
  }
}

variable "storage_app_role" {
  description = "IAM role for the application to access the storage bucket"
  type        = string
  default     = "roles/storage.objectAdmin"
}

variable "storage_enable_dev_access" {
  description = "Enable external access to the storage bucket for development"
  type        = bool
  default     = false
}

variable "storage_dev_role" {
  description = "IAM role for development access to the storage bucket"
  type        = string
  default     = "roles/storage.objectAdmin"
}

variable "storage_dev_access_members" {
  description = "List of IAM members to grant development access to the storage bucket (e.g., 'user:dev@example.com')"
  type        = list(string)
  default     = []
}

variable "storage_create_hmac_key" {
  description = "Create HMAC key for S3-compatible access to the storage bucket"
  type        = bool
  default     = false
}

variable "storage_lifecycle_rules" {
  description = "Lifecycle rules for the storage bucket"
  type = list(object({
    condition = object({
      age                   = optional(number)
      num_newer_versions    = optional(number)
      matches_prefix        = optional(list(string))
      matches_storage_class = optional(list(string))
    })
    action = object({
      type          = string
      storage_class = optional(string)
    })
  }))
  default = [
    {
      condition = {
        age            = 30
        matches_prefix = ["thumbnails/"]
      }
      action = {
        type = "Delete"
      }
    },
    {
      condition = {
        num_newer_versions = 5
      }
      action = {
        type = "Delete"
      }
    }
  ]
}

variable "storage_cors_config" {
  description = "CORS configuration for the storage bucket"
  type = list(object({
    origin          = list(string)
    method          = list(string)
    response_header = list(string)
    max_age_seconds = number
  }))
  default = [
    {
      origin          = ["*"]
      method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      response_header = ["*"]
      max_age_seconds = 3600
    }
  ]
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

variable "hrafnar_subdomain" {
  description = "Subdomain for hrafnar application access (e.g., 'hrafnar' for hrafnar.example.com)"
  type        = string
  default     = "hrafnar"
}

# Artifact Registry Configuration
variable "enable_artifact_registry" {
  description = "Enable Artifact Registry remote repository for quay.io"
  type        = bool
  default     = false
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

# Resource Tags
variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default     = {}
}
