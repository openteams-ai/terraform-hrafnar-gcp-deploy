# Artifact Registry remote repository for quay.io images
resource "google_artifact_registry_repository" "quay_remote" {
  count         = var.enable_artifact_registry ? 1 : 0
  location      = var.region
  repository_id = "quay-remote"
  description   = "Remote repository for quay.io images"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  project       = var.project_id

  remote_repository_config {
    description = "Remote repository for quay.io"
    docker_repository {
      custom_repository {
        uri = "https://quay.io"
      }
    }
  }

  labels = local.common_labels

  depends_on = [google_project_service.required_apis]
}

# Grant Cloud Run service agent permission to pull images from Artifact Registry
resource "google_artifact_registry_repository_iam_member" "cloud_run_artifact_reader" {
  count      = var.enable_artifact_registry ? 1 : 0
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.quay_remote[0].name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:service-${data.google_project.current.number}@serverless-robot-prod.iam.gserviceaccount.com"
}

# Data source to get the current project information
data "google_project" "current" {
  project_id = var.project_id
}
