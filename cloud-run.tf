# Cloud Run service for the hrafnar application
resource "google_cloud_run_service" "main_app" {
  name     = local.main_app_service_name
  location = var.region
  project  = var.project_id

  template {
    metadata {
      labels = local.common_labels
      annotations = merge({
        "autoscaling.knative.dev/minScale"         = tostring(var.app_min_instances)
        "autoscaling.knative.dev/maxScale"         = tostring(var.app_max_instances)
        "run.googleapis.com/execution-environment" = "gen2"
        # CPU allocation
        "run.googleapis.com/cpu-throttling" = "false",
        # Direct VPC Egress
        "run.googleapis.com/network-interfaces" = jsonencode([{
          "network"    = google_compute_network.main.id
          "subnetwork" = google_compute_subnetwork.private.id
          "tags"       = ["cloud-run"]
        }])
        }, {
        # Config hash annotations to force new revisions when config changes
        for name, config in var.app_config_files : "config.hash.${name}" => sha256(config.content)
      })
    }

    spec {
      service_account_name = google_service_account.app.email
      timeout_seconds      = 300

      containers {
        image = var.app_image_sha != "" ? "${var.app_image}@${var.app_image_sha}" : "${var.app_image}:${var.app_image_tag}"

        command = var.app_command

        ports {
          container_port = var.app_port
        }

        # Volume mounts for config files
        dynamic "volume_mounts" {
          for_each = var.app_config_files
          content {
            name       = "config-${volume_mounts.key}"
            mount_path = dirname(volume_mounts.value.mount_path)
          }
        }

        resources {
          limits = {
            cpu    = var.app_cpu
            memory = var.app_memory
          }
        }

        # Environment variables (non-sensitive)
        dynamic "env" {
          for_each = local.app_environment_vars
          content {
            name  = env.key
            value = env.value
          }
        }

        # Secret Manager references for AI API keys
        dynamic "env" {
          for_each = local.ai_api_key_secrets
          content {
            name = env.key
            value_from {
              secret_key_ref {
                name = env.value
                key  = "latest"
              }
            }
          }
        }

        # Database connection string from Secret Manager (if database is enabled)
        dynamic "env" {
          for_each = var.enable_database ? [1] : []
          content {
            name = "HRAFNAR_STORAGE_PERSISTENT_DATABASE_DSN"
            value_from {
              secret_key_ref {
                name = local.db_connection_secret
                key  = "latest"
              }
            }
          }
        }

        # MCP server API keys from Secret Manager (if configured)
        dynamic "env" {
          for_each = {
            for name, config in var.mcp_servers : "MCP_${upper(name)}_API_KEY" => "${local.resource_prefix}-mcp-${name}-key"
            if config.api_key != null && config.api_key != ""
          }
          content {
            name = env.key
            value_from {
              secret_key_ref {
                name = env.value
                key  = "latest"
              }
            }
          }
        }

        # Valkey connection URL from Secret Manager (if enabled)
        dynamic "env" {
          for_each = var.enable_valkey ? [1] : []
          content {
            name = "VALKEY_URL"
            value_from {
              secret_key_ref {
                name = local.valkey_connection_secret
                key  = "latest"
              }
            }
          }
        }

        # Redis URL for backwards compatibility (if enabled)
        dynamic "env" {
          for_each = var.enable_valkey ? [1] : []
          content {
            name = "REDIS_URL"
            value_from {
              secret_key_ref {
                name = local.valkey_connection_secret
                key  = "latest"
              }
            }
          }
        }

        # Valkey/Redis auth string from Secret Manager (if auth is enabled)
        dynamic "env" {
          for_each = var.enable_valkey && var.valkey_auth_enabled ? [1] : []
          content {
            name = "VALKEY_AUTH"
            value_from {
              secret_key_ref {
                name = local.valkey_auth_secret
                key  = "latest"
              }
            }
          }
        }

        # Storage HMAC access ID from Secret Manager (if storage and HMAC are enabled)
        dynamic "env" {
          for_each = var.enable_storage && var.storage_create_hmac_key ? [1] : []
          content {
            name = "STORAGE_HMAC_ACCESS_ID"
            value_from {
              secret_key_ref {
                name = google_secret_manager_secret.storage_hmac_access_id[0].secret_id
                key  = "latest"
              }
            }
          }
        }

        # Storage HMAC secret key from Secret Manager (if storage and HMAC are enabled)
        dynamic "env" {
          for_each = var.enable_storage && var.storage_create_hmac_key ? [1] : []
          content {
            name = "STORAGE_HMAC_SECRET"
            value_from {
              secret_key_ref {
                name = google_secret_manager_secret.storage_hmac_secret[0].secret_id
                key  = "latest"
              }
            }
          }
        }

        # Health check
        liveness_probe {
          http_get {
            path = "/health"
            port = var.app_port
          }
          initial_delay_seconds = 30
          timeout_seconds       = 5
          period_seconds        = 30
          failure_threshold     = 3
        }

        startup_probe {
          http_get {
            path = "/health"
            port = var.app_port
          }
          initial_delay_seconds = 0
          timeout_seconds       = 10
          period_seconds        = 10
          failure_threshold     = 10
        }
      }

      # Volumes for config files
      dynamic "volumes" {
        for_each = var.app_config_files
        content {
          name = "config-${volumes.key}"
          secret {
            secret_name  = google_secret_manager_secret.config_files[volumes.key].secret_id
            default_mode = 0444 # Read-only for owner, group, others
            items {
              key  = "latest"
              path = basename(volumes.value.mount_path)
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.required_apis,
    google_secret_manager_secret_version.ai_api_keys,
    google_secret_manager_secret_version.db_connection,
    google_secret_manager_secret_version.mcp_api_keys,
    google_secret_manager_secret_version.config_files,
    google_secret_manager_secret_version.valkey_connection,
    google_secret_manager_secret_version.valkey_auth,
    google_artifact_registry_repository.quay_remote,
    google_artifact_registry_repository_iam_member.cloud_run_artifact_reader
  ]
}

# IAM policy to allow public access to the hrafnar application
resource "google_cloud_run_service_iam_member" "main_app_public" {
  location = google_cloud_run_service.main_app.location
  project  = google_cloud_run_service.main_app.project
  service  = google_cloud_run_service.main_app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Domain mapping for the hrafnar application (if Cloudflare DNS is enabled)
# Domain mapping for the application
resource "google_cloud_run_domain_mapping" "main_app" {
  count    = var.enable_cloudflare_dns && var.base_domain != "" ? 1 : 0
  location = var.region
  name     = local.app_fqdn
  project  = var.project_id

  metadata {
    namespace = var.project_id
    labels    = local.common_labels
  }

  spec {
    route_name = google_cloud_run_service.main_app.name
  }

  depends_on = [google_cloud_run_service.main_app]
}
