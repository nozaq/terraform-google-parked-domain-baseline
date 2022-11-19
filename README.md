# terraform-google-parked-domain-baseline

[![Github Actions](https://github.com/nozaq/terraform-google-parked-domain-baseline/actions/workflows/main.yml/badge.svg)](https://github.com/nozaq/terraform-google-parked-domain-baseline/actions/workflows/main.yml)
[![Releases](https://img.shields.io/github/v/release/nozaq/terraform-google-parked-domain-baseline)](https://github.com/nozaq/terraform-google-parked-domain-baseline/releases/latest)

[Terraform Module Registry](https://registry.terraform.io/modules/nozaq/parked-domain-baseline/google)

A terraform module to set up DNS records to harden the parked(unused) domain using GCP Cloud DNS.

Domains should be protected for email spoofing even if they are not intended to be actively used.
This module configures DNS records to protect such domain based on [M3AAWG Protecting Parked Domains Best Common Practices].

## Features

This module creates the following DNS records.

- Null MX record([RFC 7505]) to indicate the domain does not accept any email.
- SPF record to indicate no IP is authorized to send email on behalf of this domain.
- DMARC record to enforce receiving domains to reject any email forging this domain.
- Optionally adds `rua` tag in the DMARC record to receive aggregate feedback reports via email. 
- Optionally creates Null MX and DMARC records for wildcard subdomains as well as the root domain(enabled by default).

## Usage

```hcl
provider "google" {
}

module "parked_domain" {
  source = "nozaq/parked-domain-baseline/google"

  zone_name           = "example.com"
  ttl                 = 86400
  include_subdomains  = true
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.43 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.43 |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | The DNS zone name to add the records to. | `string` | yes |
| <a name="input_aggregate_feedback_email"></a> [aggregate\_feedback\_email](#input\_aggregate\_feedback\_email) | The email address to which aggregate feedback is to be sent. | `string` | no |
| <a name="input_include_subdomains"></a> [include\_subdomains](#input\_include\_subdomains) | Configure all subdomains as well as the root domain. | `bool` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | The TTL of the DNS records. | `number` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

[M3AAWG Protecting Parked Domains Best Common Practices]: https://www.m3aawg.org/sites/default/files/m3aawg_parked_domains_bcp-2022-06.pdf
[RFC 7505]: https://datatracker.ietf.org/doc/rfc7505/
