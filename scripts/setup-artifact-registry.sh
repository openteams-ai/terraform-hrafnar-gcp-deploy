#!/bin/bash
# One-time setup script for Artifact Registry remote repository
# This enables Cloud Run to pull images from quay.io

set -e

# Default values
PROJECT_ID="${PROJECT_ID:-}"
REGION="${REGION:-us-central1}"
REPOSITORY_ID="quay-remote"

# Check if PROJECT_ID is set
if [ -z "$PROJECT_ID" ]; then
    echo "Error: PROJECT_ID environment variable must be set"
    echo "Usage: PROJECT_ID=your-project-id ./setup-artifact-registry.sh"
    exit 1
fi

echo "Setting up Artifact Registry remote repository for quay.io..."
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"
echo "Repository ID: $REPOSITORY_ID"

# Enable required APIs
echo "Enabling Artifact Registry API..."
gcloud services enable artifactregistry.googleapis.com --project="$PROJECT_ID"

# Check if repository already exists
if gcloud artifacts repositories describe "$REPOSITORY_ID" --location="$REGION" --project="$PROJECT_ID" &>/dev/null; then
    echo "Repository $REPOSITORY_ID already exists in $REGION"
else
    echo "Creating Artifact Registry remote repository..."
    gcloud artifacts repositories create "$REPOSITORY_ID" \
        --repository-format=docker \
        --mode=remote-repository \
        --location="$REGION" \
        --description="Remote repository for quay.io images" \
        --remote-docker-repo=https://quay.io \
        --project="$PROJECT_ID"

    echo "Repository created successfully!"
fi

echo ""
echo "Setup complete! You can now use images from quay.io through Artifact Registry."
echo ""
echo "To use an image from quay.io, replace the registry URL:"
echo "  Original: quay.io/reiemp/hrafnar:latest"
echo "  New:      ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_ID}/reiemp/hrafnar:latest"
echo ""
echo "Example in Terraform:"
echo "  app_image = \"${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_ID}/reiemp/hrafnar\""
echo "  app_image_tag = \"latest\""
