# Service account for the hrafnar application
resource "google_service_account" "app" {
  account_id   = local.app_service_account
  display_name = "Cloud Run service account for ${local.resource_prefix} hrafnar application"
  project      = var.project_id
}

# Service account for the React frontend (if enabled)
resource "google_service_account" "react" {
  count        = var.enable_react_frontend ? 1 : 0
  account_id   = local.react_service_account
  display_name = "Cloud Run service account for ${local.resource_prefix} React frontend"
  project      = var.project_id
}

# IAM binding for hrafnar app to access Secret Manager secrets
resource "google_secret_manager_secret_iam_member" "app_db_password" {
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
  project   = var.project_id
}

resource "google_secret_manager_secret_iam_member" "app_db_connection" {
  secret_id = google_secret_manager_secret.db_connection.secret_id
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
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app.email}"
}

# IAM binding for hrafnar app to access Cloud SQL instances
resource "google_project_iam_member" "app_cloudsql_instanceuser" {
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

# IAM binding for React frontend monitoring (if enabled)
resource "google_project_iam_member" "react_monitoring_writer" {
  count   = var.enable_react_frontend && var.enable_monitoring ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.react[0].email}"
}

resource "google_project_iam_member" "react_logging_writer" {
  count   = var.enable_react_frontend && var.enable_monitoring ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.react[0].email}"
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])

  project = var.project_id
  service = each.key

  disable_on_destroy = false
}