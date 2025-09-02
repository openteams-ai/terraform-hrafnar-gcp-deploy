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
