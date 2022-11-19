terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.43"
    }
  }
  required_version = ">= 1.3"
}

data "google_dns_managed_zone" "this" {
  name = var.zone_name
}

# Null MX record specified in RFC 7505
# https://datatracker.ietf.org/doc/rfc7505/
resource "google_dns_record_set" "mx_root" {
  managed_zone = var.zone_name
  type         = "MX"
  name         = data.google_dns_managed_zone.this.dns_name
  rrdatas      = ["0 ."]
  ttl          = var.ttl
}

resource "google_dns_record_set" "mx_subdomains" {
  count = var.include_subdomains ? 1 : 0

  managed_zone = var.zone_name
  type         = "MX"
  name         = "*.${data.google_dns_managed_zone.this.dns_name}"
  rrdatas      = ["0 ."]
  ttl          = var.ttl
}

# Ensure all SPF validations to fail for the root domain.
resource "google_dns_record_set" "spf_root" {
  managed_zone = var.zone_name
  type         = "TXT"
  name         = data.google_dns_managed_zone.this.dns_name
  rrdatas      = ["v=spf1 -all"]
  ttl          = var.ttl
}

# Ensure all SPF validations to fail for subdomains.
resource "google_dns_record_set" "spf_subdomains" {
  count = var.include_subdomains ? 1 : 0

  managed_zone = var.zone_name
  type         = "TXT"
  name         = "*.${data.google_dns_managed_zone.this.dns_name}"
  rrdatas      = ["v=spf1 -all"]
  ttl          = var.ttl
}

# Advise receivers to reject emails when DMARC alignment fails.
resource "google_dns_record_set" "dmarc" {
  managed_zone = var.zone_name
  type         = "TXT"
  name         = "_dmarc.${data.google_dns_managed_zone.this.dns_name}"
  rrdatas      = [var.aggregate_feedback_email != "" ? "v=DMARC1; p=reject; rua=${var.aggregate_feedback_email}" : "v=DMARC1; p=reject;"]
  ttl          = var.ttl
}

