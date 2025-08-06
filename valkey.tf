# Google Cloud Memorystore for Redis (Valkey-compatible)
# Redis instances deployed in this module are compatible with Valkey clients

resource "google_redis_instance" "valkey" {
  count                   = var.enable_valkey ? 1 : 0
  name                    = local.valkey_instance_name
  tier                    = var.valkey_tier
  memory_size_gb          = var.valkey_memory_size_gb
  region                  = var.region
  project                 = var.project_id
  location_id             = "${var.region}-a"
  alternative_location_id = var.valkey_tier == "STANDARD_HA" ? "${var.region}-b" : null

  authorized_network = google_compute_network.main.id
  redis_version      = var.valkey_redis_version
  display_name       = "${local.resource_prefix} Valkey/Redis Instance"
  reserved_ip_range  = local.valkey_reserved_ip_range

  # Security configuration
  auth_enabled            = var.valkey_auth_enabled
  transit_encryption_mode = var.valkey_transit_encryption_mode

  # Configuration parameters
  redis_configs = var.valkey_redis_configs

  # Maintenance policy
  maintenance_policy {
    weekly_maintenance_window {
      day = var.valkey_maintenance_policy.weekly_maintenance_window.day
      start_time {
        hours   = var.valkey_maintenance_policy.weekly_maintenance_window.start_time.hours
        minutes = var.valkey_maintenance_policy.weekly_maintenance_window.start_time.minutes
        seconds = var.valkey_maintenance_policy.weekly_maintenance_window.start_time.seconds
        nanos   = var.valkey_maintenance_policy.weekly_maintenance_window.start_time.nanos
      }
    }
  }

  labels = merge(local.common_labels, {
    service_type     = "valkey"
    redis_compatible = "true"
  })

  depends_on = [
    google_project_service.required_apis,
    google_compute_network.main
  ]

  lifecycle {
    prevent_destroy = true
  }

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

# Store Valkey/Redis connection details in Secret Manager
resource "google_secret_manager_secret" "valkey_connection" {
  count     = var.enable_valkey ? 1 : 0
  secret_id = local.valkey_connection_secret
  project   = var.project_id

  labels = merge(local.common_labels, {
    service_type = "valkey"
  })

  replication {
    auto {}
  }

  depends_on = [google_project_service.required_apis]
}

resource "google_secret_manager_secret_version" "valkey_connection" {
  count       = var.enable_valkey ? 1 : 0
  secret      = google_secret_manager_secret.valkey_connection[0].id
  secret_data = local.valkey_connection_string
}

# Store Valkey/Redis auth string in Secret Manager (if auth is enabled)
resource "google_secret_manager_secret" "valkey_auth" {
  count     = var.enable_valkey && var.valkey_auth_enabled ? 1 : 0
  secret_id = local.valkey_auth_secret
  project   = var.project_id

  labels = merge(local.common_labels, {
    service_type = "valkey"
  })

  replication {
    auto {}
  }

  depends_on = [google_project_service.required_apis]
}

resource "google_secret_manager_secret_version" "valkey_auth" {
  count       = var.enable_valkey && var.valkey_auth_enabled ? 1 : 0
  secret      = google_secret_manager_secret.valkey_auth[0].id
  secret_data = google_redis_instance.valkey[0].auth_string
}
