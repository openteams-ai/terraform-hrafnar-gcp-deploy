# Terraform and provider version constraints
# Define required versions for Terraform and providers

terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    # google-beta = {
    #   source  = "hashicorp/google-beta"
    #   version = "~> 5.0"
    # }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
