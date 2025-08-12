# Cloud Storage bucket for hrafner app
resource "google_storage_bucket" "hrafner_storage" {
  count = var.enable_storage ? 1 : 0

  name          = "${var.project_id}-${var.name_prefix}-storage"
  location      = var.region
  force_destroy = var.storage_force_destroy

  # Enable uniform bucket-level access for better security
  uniform_bucket_level_access = true

  # Versioning for data protection
  versioning {
    enabled = var.storage_versioning_enabled
  }

  # Lifecycle rules for managing old versions and temporary files
  dynamic "lifecycle_rule" {
    for_each = var.storage_lifecycle_rules
    content {
      condition {
        age                   = lookup(lifecycle_rule.value.condition, "age", null)
        num_newer_versions    = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        matches_prefix        = lookup(lifecycle_rule.value.condition, "matches_prefix", [])
        matches_storage_class = lookup(lifecycle_rule.value.condition, "matches_storage_class", [])
      }
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
    }
  }

  # Public access prevention for security
  public_access_prevention = var.storage_public_access_prevention

  # CORS configuration for web access
  dynamic "cors" {
    for_each = var.storage_cors_config
    content {
      origin          = cors.value.origin
      method          = cors.value.method
      response_header = cors.value.response_header
      max_age_seconds = cors.value.max_age_seconds
    }
  }

  labels = merge(
    var.labels,
    {
      component = "storage"
      purpose   = "app-storage"
    }
  )
}

# Create the subdirectory structure (folders) in the bucket
resource "google_storage_bucket_object" "storage_folders" {
  for_each = var.enable_storage ? toset(var.storage_folders) : []

  name    = "${each.value}/"
  content = " "
  bucket  = google_storage_bucket.hrafner_storage[0].name
}

# IAM binding to give the hrafner app service account storage access
resource "google_storage_bucket_iam_member" "hrafner_app_storage_access" {
  count = var.enable_storage ? 1 : 0

  bucket = google_storage_bucket.hrafner_storage[0].name
  role   = var.storage_app_role
  member = "serviceAccount:${google_service_account.app.email}"
}

# IAM binding for development access (optional)
resource "google_storage_bucket_iam_member" "dev_storage_access" {
  count = var.enable_storage && var.storage_enable_dev_access ? length(var.storage_dev_access_members) : 0

  bucket = google_storage_bucket.hrafner_storage[0].name
  role   = var.storage_dev_role
  member = var.storage_dev_access_members[count.index]
}

# Generate HMAC key for service account (for S3-compatible access)
resource "google_storage_hmac_key" "hrafner_storage_hmac" {
  count = var.enable_storage && var.storage_create_hmac_key ? 1 : 0

  service_account_email = google_service_account.app.email
}

# Store HMAC keys in Secret Manager
resource "google_secret_manager_secret" "storage_hmac_access_id" {
  count = var.enable_storage && var.storage_create_hmac_key ? 1 : 0

  secret_id = "${var.name_prefix}-storage-hmac-access-id"

  replication {
    auto {}
  }

  labels = merge(
    var.labels,
    {
      component = "storage"
      type      = "hmac-access-id"
    }
  )
}

resource "google_secret_manager_secret_version" "storage_hmac_access_id" {
  count = var.enable_storage && var.storage_create_hmac_key ? 1 : 0

  secret      = google_secret_manager_secret.storage_hmac_access_id[0].id
  secret_data = google_storage_hmac_key.hrafner_storage_hmac[0].access_id
}

resource "google_secret_manager_secret" "storage_hmac_secret" {
  count = var.enable_storage && var.storage_create_hmac_key ? 1 : 0

  secret_id = "${var.name_prefix}-storage-hmac-secret"

  replication {
    auto {}
  }

  labels = merge(
    var.labels,
    {
      component = "storage"
      type      = "hmac-secret"
    }
  )
}

resource "google_secret_manager_secret_version" "storage_hmac_secret" {
  count = var.enable_storage && var.storage_create_hmac_key ? 1 : 0

  secret      = google_secret_manager_secret.storage_hmac_secret[0].id
  secret_data = google_storage_hmac_key.hrafner_storage_hmac[0].secret
}
