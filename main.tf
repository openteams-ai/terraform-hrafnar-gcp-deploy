# This module deploys a Hrafnar AI application on Google Cloud Platform
# Main resources are defined in their respective files:
# - cloud-run.tf: Cloud Run service configuration
# - database.tf: Cloud SQL PostgreSQL setup
# - networking.tf: VPC, subnets, and VPC connector
# - secrets.tf: Secret Manager for API keys and config files
# - iam.tf: Service accounts, IAM roles, and API enablement
# - dns.tf: Cloudflare DNS configuration (optional)
