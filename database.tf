# Random password for database user
resource "random_password" "db_password" {
  count   = var.enable_database ? 1 : 0
  length  = 32
  special = true
}

# Cloud SQL PostgreSQL instance
resource "google_sql_database_instance" "main" {
  count            = var.enable_database ? 1 : 0
  name             = local.database_name
  database_version = "POSTGRES_15"
  region           = var.region
  project          = var.project_id

  # Prevent accidental deletion
  deletion_protection = true

  settings {
    tier                        = var.database_tier
    disk_size                   = var.database_disk_size
    disk_type                   = "PD_SSD"
    disk_autoresize             = true
    disk_autoresize_limit       = var.database_disk_autoresize_limit
    availability_type           = "ZONAL"
    deletion_protection_enabled = true

    # Backup configuration
    backup_configuration {
      enabled                        = var.database_backup_enabled
      start_time                     = "02:00"
      location                       = var.region
      point_in_time_recovery_enabled = var.database_backup_enabled
      transaction_log_retention_days = var.database_log_retention_days
      backup_retention_settings {
        retained_backups = var.database_backup_retention_days
        retention_unit   = "COUNT"
      }
    }

    # IP configuration for private networking
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.main.id
      enable_private_path_for_google_cloud_services = true
      ssl_mode                                      = var.database_ssl_mode
    }

    # Database flags for optimal performance
    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    database_flags {
      name  = "log_min_duration_statement"
      value = "1000"
    }

    # Maintenance window
    maintenance_window {
      day  = 7 # Sunday
      hour = 3 # 3 AM
    }

    # Insights configuration
    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }
  }

  depends_on = [
    google_service_networking_connection.private_vpc_connection[0],
    google_project_service.required_apis
  ]
}

# Private service connection for Cloud SQL
resource "google_compute_global_address" "private_ip_address" {
  count         = var.enable_database ? 1 : 0
  name          = "${local.resource_prefix}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  address       = "10.1.0.0" # Explicitly assign to non-overlapping range with cloud run subnetwork
  network       = google_compute_network.main.id
  project       = var.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.enable_database ? 1 : 0
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address[0].name]

  depends_on = [google_project_service.required_apis]
}

# Database
resource "google_sql_database" "main" {
  count    = var.enable_database ? 1 : 0
  name     = local.database_name
  instance = google_sql_database_instance.main[0].name
  project  = var.project_id
}

# Database user
resource "google_sql_user" "main" {
  count    = var.enable_database ? 1 : 0
  name     = local.database_user
  instance = google_sql_database_instance.main[0].name
  password = random_password.db_password[0].result
  project  = var.project_id
}

# Store database password in Secret Manager
resource "google_secret_manager_secret" "db_password" {
  count     = var.enable_database ? 1 : 0
  secret_id = local.db_password_secret_name
  project   = var.project_id

  labels = local.common_labels

  replication {
    auto {}
  }

  depends_on = [google_project_service.required_apis]
}

resource "google_secret_manager_secret_version" "db_password" {
  count       = var.enable_database ? 1 : 0
  secret      = google_secret_manager_secret.db_password[0].id
  secret_data = random_password.db_password[0].result
}
