variable "zone_name" {
  description = " The DNS zone name to add the records to."
  type        = string
}

variable "ttl" {
  description = "The TTL of the DNS records."
  type        = number
  default     = 300
}

variable "aggregate_feedback_email" {
  description = "The email address to which aggregate feedback is to be sent."
  type        = string
  default     = ""
}

variable "include_subdomains" {
  description = "Configure all subdomains as well as the root domain."
  type        = bool
  default     = true
}
