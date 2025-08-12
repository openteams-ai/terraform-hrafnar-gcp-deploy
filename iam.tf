# Service account for the hrafnar application
resource "google_service_account" "app" {
  account_id   = local.app_service_account
  display_name = "Cloud Run service account for ${local.resource_prefix} hrafnar application"
  project      = var.project_id
}


# IAM binding for hrafnar app to access Secret Manager secrets (database)
resource "google_secret_manager_secret_iam_member" "app_db_password" {
  count     = var.enable_database ? 1 : 0
  secret_id = google_secret_manager_secret.db_password[0].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
  project   = var.project_id
}

resource "google_secret_manager_secret_iam_member" "app_db_connection" {
  count     = var.enable_database ? 1 : 0
  secret_id = google_secret_manager_secret.db_connection[0].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
  project   = var.project_id
}

# IAM bindings for AI API key secrets
resource "google_secret_manager_secret_iam_member" "app_ai_api_keys" {
  for_each = nonsensitive(toset(keys(var.ai_api_keys)))

  secret_id = google_secret_manager_secret.ai_api_keys[each.key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
  project   = var.project_id
}

# IAM bindings for MCP server API key secrets
resource "google_secret_manager_secret_iam_member" "app_mcp_api_keys" {
  for_each = {
    for name, config in var.mcp_servers : name => config
    if config.api_key != null && config.api_key != ""
  }

  secret_id = google_secret_manager_secret.mcp_api_keys[each.key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
  project   = var.project_id
}

# IAM binding for hrafnar app to access Cloud SQL
resource "google_project_iam_member" "app_cloudsql_client" {
  count   = var.enable_database ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app.email}"
}

# IAM binding for hrafnar app to access Cloud SQL instances
resource "google_project_iam_member" "app_cloudsql_instanceuser" {
  count   = var.enable_database ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.app.email}"
}

# IAM binding for monitoring (if enabled)
resource "google_project_iam_member" "app_monitoring_writer" {
  count   = var.enable_monitoring ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.app.email}"
}

resource "google_project_iam_member" "app_logging_writer" {
  count   = var.enable_monitoring ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.app.email}"
}


# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",                  # Cloud Run
    "secretmanager.googleapis.com",        # Secret Manager
    "compute.googleapis.com",              # Compute Engine (for VPC)
    "servicenetworking.googleapis.com",    # Service Networking (for Cloud SQL private IP)
    "sqladmin.googleapis.com",             # Cloud SQL Admin API
    "sql-component.googleapis.com",        # Cloud SQL Component API
    "vpcaccess.googleapis.com",            # VPC Access (for VPC connector)
    "iam.googleapis.com",                  # Identity and Access Management
    "cloudresourcemanager.googleapis.com", # Cloud Resource Manager
    "redis.googleapis.com"                 # Cloud Memorystore for Redis (Valkey-compatible)
  ])

  project = var.project_id
  service = each.key

  disable_dependent_services = false
  disable_on_destroy         = false

  timeouts {
    create = "10m"
    update = "10m"
  }
}

# Grant read access to config file secrets
resource "google_secret_manager_secret_iam_member" "app_config_files" {
  for_each  = var.app_config_files
  project   = var.project_id
  secret_id = google_secret_manager_secret.config_files[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
}

# Grant read access to Valkey connection secret
resource "google_secret_manager_secret_iam_member" "app_valkey_connection" {
  count     = var.enable_valkey ? 1 : 0
  project   = var.project_id
  secret_id = google_secret_manager_secret.valkey_connection[0].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
}

# Grant read access to Valkey auth secret
resource "google_secret_manager_secret_iam_member" "app_valkey_auth" {
  count     = var.enable_valkey && var.valkey_auth_enabled ? 1 : 0
  project   = var.project_id
  secret_id = google_secret_manager_secret.valkey_auth[0].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
}

# Grant read access to storage HMAC access ID secret
resource "google_secret_manager_secret_iam_member" "app_storage_hmac_access_id" {
  count     = var.enable_storage && var.storage_create_hmac_key ? 1 : 0
  project   = var.project_id
  secret_id = google_secret_manager_secret.storage_hmac_access_id[0].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
}

# Grant read access to storage HMAC secret key
resource "google_secret_manager_secret_iam_member" "app_storage_hmac_secret" {
  count     = var.enable_storage && var.storage_create_hmac_key ? 1 : 0
  project   = var.project_id
  secret_id = google_secret_manager_secret.storage_hmac_secret[0].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
}
