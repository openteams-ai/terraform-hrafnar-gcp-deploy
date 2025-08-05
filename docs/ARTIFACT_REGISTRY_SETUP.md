# Artifact Registry Setup for External Container Images

## Overview

Google Cloud Run now restricts container image sources to:
- `gcr.io` (Google Container Registry)
- `*.docker.pkg.dev` (Artifact Registry)
- `docker.io` (Docker Hub)

To use images from other registries like `quay.io`, you must set up an Artifact Registry remote repository that acts as a proxy.

## One-Time Setup

This setup only needs to be done once per GCP project.

### Option 1: Using the Setup Script

1. Run the provided setup script:
   ```bash
   cd scripts
   PROJECT_ID=your-project-id ./setup-artifact-registry.sh
   ```

2. The script will:
   - Enable the Artifact Registry API
   - Create a remote repository named `quay-remote`
   - Configure it to proxy quay.io

### Option 2: Manual Setup

1. Enable the Artifact Registry API:
   ```bash
   gcloud services enable artifactregistry.googleapis.com
   ```

2. Create the remote repository:
   ```bash
   gcloud artifacts repositories create quay-remote \
     --repository-format=docker \
     --mode=remote-repository \
     --location=us-central1 \
     --description="Remote repository for quay.io images" \
     --remote-docker-repo=https://quay.io
   ```

## Using the Remote Repository

After setup, you need to update your image URLs:

### Original Image URL
```
quay.io/reiemp/hrafnar:latest
```

### New Image URL
```
us-central1-docker.pkg.dev/YOUR_PROJECT_ID/quay-remote/reiemp/hrafnar:latest
```

### In Terraform

Update your module configuration:

```hcl
module "hrafnar_deploy" {
  source = "../.."
  
  project_id    = "your-project-id"
  name_prefix   = "my-app"
  app_image     = "us-central1-docker.pkg.dev/your-project-id/quay-remote/reiemp/hrafnar"
  app_image_tag = "latest"
  
  # ... other configuration
}
```

## Testing

To verify the setup works:

1. Test pulling an image through the remote repository:
   ```bash
   docker pull us-central1-docker.pkg.dev/YOUR_PROJECT_ID/quay-remote/reiemp/hrafnar:latest
   ```

2. Deploy to Cloud Run:
   ```bash
   gcloud run deploy test-app \
     --image=us-central1-docker.pkg.dev/YOUR_PROJECT_ID/quay-remote/reiemp/hrafnar:latest \
     --region=us-central1
   ```

## Troubleshooting

### Authentication Issues
If the quay.io repository requires authentication:
1. Store credentials in Secret Manager
2. Configure the remote repository with authentication:
   ```bash
   gcloud artifacts repositories update quay-remote \
     --location=us-central1 \
     --remote-username=YOUR_USERNAME \
     --remote-password-secret-version=projects/PROJECT_ID/secrets/quay-password/versions/latest
   ```

### Image Not Found
- Verify the original image exists on quay.io
- Check that the repository path is correct
- Ensure the Artifact Registry API is enabled

### Performance
- First pull will be slower as it fetches from quay.io
- Subsequent pulls use the cached version in Artifact Registry
- Configure cleanup policies to manage storage costs