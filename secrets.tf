# Individual Secret Manager secrets for each AI API key
resource "google_secret_manager_secret" "ai_api_keys" {
  for_each = nonsensitive(toset(keys(var.ai_api_keys)))

  secret_id = "${local.resource_prefix}-${lower(replace(each.key, "_", "-"))}"
  project   = var.project_id

  labels = merge(local.common_labels, {
    ai_provider = lower(replace(each.key, "_API_KEY", ""))
  })

  replication {
    auto {}
  }
}

# Store each AI API key value in its respective secret
resource "google_secret_manager_secret_version" "ai_api_keys" {
  for_each = nonsensitive(toset(keys(var.ai_api_keys)))

  secret      = google_secret_manager_secret.ai_api_keys[each.key].id
  secret_data = sensitive(var.ai_api_keys[each.key])
}

# Individual secrets for MCP server API keys (if provided)
resource "google_secret_manager_secret" "mcp_api_keys" {
  for_each = {
    for name, config in var.mcp_servers : name => config
    if config.api_key != null && config.api_key != ""
  }

  secret_id = "${local.resource_prefix}-mcp-${each.key}-key"
  project   = var.project_id

  labels = merge(local.common_labels, {
    mcp_server = each.key
  })

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "mcp_api_keys" {
  for_each = {
    for name, config in var.mcp_servers : name => config
    if config.api_key != null && config.api_key != ""
  }

  secret      = google_secret_manager_secret.mcp_api_keys[each.key].id
  secret_data = each.value.api_key
}

# Database connection string secret
resource "google_secret_manager_secret" "db_connection" {
  count     = var.enable_database ? 1 : 0
  secret_id = local.db_connection_secret
  project   = var.project_id

  labels = local.common_labels

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_connection" {
  count       = var.enable_database ? 1 : 0
  secret      = google_secret_manager_secret.db_connection[0].id
  secret_data = "postgresql://${local.database_user}:${random_password.db_password[0].result}@${google_sql_database_instance.main[0].connection_name}/${local.database_name}"
}

# Secret Manager secrets for config files
resource "google_secret_manager_secret" "config_files" {
  for_each  = var.app_config_files
  secret_id = "${local.resource_prefix}-config-${each.key}"
  project   = var.project_id

  replication {
    auto {}
  }

  labels = local.common_labels

  depends_on = [google_project_service.required_apis]
}

# Secret versions for config files
resource "google_secret_manager_secret_version" "config_files" {
  for_each    = var.app_config_files
  secret      = google_secret_manager_secret.config_files[each.key].id
  secret_data = each.value.content
}
