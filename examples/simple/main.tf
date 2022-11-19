terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.43"
    }
  }

  required_version = ">= 1.3"
}

provider "google" {
  project = var.project_id
}

module "parked_domain" {
  source = "../../"

  zone_name = "example.com"
  ttl       = 86400 # One day
}
