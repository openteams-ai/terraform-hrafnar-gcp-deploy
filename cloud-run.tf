# Cloud Run service for the hrafnar application
resource "google_cloud_run_service" "main_app" {
  name     = local.main_app_service_name
  location = var.region
  project  = var.project_id

  template {
    metadata {
      labels = local.common_labels
      annotations = {
        "autoscaling.knative.dev/minScale"         = tostring(var.app_min_instances)
        "autoscaling.knative.dev/maxScale"         = tostring(var.app_max_instances)
        "run.googleapis.com/execution-environment" = "gen2"
        # VPC connector annotation (if enabled)
        "run.googleapis.com/vpc-access-connector" = var.enable_vpc_connector ? google_vpc_access_connector.main[0].name : null
        "run.googleapis.com/vpc-access-egress"    = var.enable_vpc_connector ? "private-ranges-only" : null
        # CPU allocation
        "run.googleapis.com/cpu-throttling" = "false"
      }
    }

    spec {
      service_account_name = google_service_account.app.email
      timeout_seconds      = 300

      containers {
        image = "${var.app_image}:${var.app_image_tag}"

        command = var.app_command

        ports {
          container_port = var.app_port
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
            name = "DATABASE_URL"
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
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.required_apis,
    google_secret_manager_secret_version.ai_api_keys
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
