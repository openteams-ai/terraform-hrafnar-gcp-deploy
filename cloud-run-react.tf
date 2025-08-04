# Cloud Run service for the React frontend (optional)
resource "google_cloud_run_service" "react_frontend" {
  count    = var.enable_react_frontend ? 1 : 0
  name     = local.react_service_name
  location = var.region
  project  = var.project_id

  template {
    metadata {
      labels = local.common_labels
      annotations = {
        "autoscaling.knative.dev/minScale"         = tostring(var.react_min_instances)
        "autoscaling.knative.dev/maxScale"         = tostring(var.react_max_instances)
        "run.googleapis.com/execution-environment" = "gen2"
        # CPU allocation
        "run.googleapis.com/cpu-throttling" = "false"
      }
    }

    spec {
      service_account_name = google_service_account.react[0].email
      timeout_seconds      = 300

      containers {
        image = var.react_image

        ports {
          container_port = 80
        }

        resources {
          limits = {
            cpu    = var.react_cpu
            memory = var.react_memory
          }
        }

        # Environment variables for React frontend
        env {
          name  = "REACT_APP_API_URL"
          value = var.enable_cloudflare_dns && var.base_domain != "" ? "https://${local.api_fqdn}" : google_cloud_run_service.main_app.status[0].url
        }

        env {
          name  = "NODE_ENV"
          value = "production"
        }

        # Health check
        liveness_probe {
          http_get {
            path = "/"
            port = 80
          }
          initial_delay_seconds = 30
          timeout_seconds       = 5
          period_seconds        = 30
          failure_threshold     = 3
        }

        startup_probe {
          http_get {
            path = "/"
            port = 80
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
    google_cloud_run_service.main_app
  ]
}

# IAM policy to allow public access to the React frontend
resource "google_cloud_run_service_iam_member" "react_frontend_public" {
  count    = var.enable_react_frontend ? 1 : 0
  location = google_cloud_run_service.react_frontend[0].location
  project  = google_cloud_run_service.react_frontend[0].project
  service  = google_cloud_run_service.react_frontend[0].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Domain mapping for the React frontend UI (if enabled)
resource "google_cloud_run_domain_mapping" "react_frontend" {
  count = var.enable_react_frontend && var.enable_cloudflare_dns && var.base_domain != "" ? 1 : 0

  location = var.region
  name     = local.ui_fqdn
  project  = var.project_id

  metadata {
    namespace = var.project_id
    labels    = local.common_labels
  }

  spec {
    route_name = google_cloud_run_service.react_frontend[0].name
  }

  depends_on = [google_cloud_run_service.react_frontend]
}
