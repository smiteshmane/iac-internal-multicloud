variable "zone_name" {
  type        = string
  description = "The unique name of the DNS managed zone."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.zone_name))
    error_message = "The zone_name must start with a letter, contain lowercase letters, numbers, or hyphens, and be up to 63 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Cloud DNS managed zone will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "dns_name" {
  type        = string
  description = "The DNS domain name ending with a trailing dot (e.g. example.internal. or app.domain.com.)."

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+\\.$", var.dns_name))
    error_message = "The dns_name must be a valid FQDN ending with a trailing dot (e.g. internal.domain.com.)."
  }
}

variable "description" {
  type        = string
  description = "A textual description of the DNS managed zone."
  default     = "Managed DNS zone created by Terraform."
}

variable "visibility" {
  type        = string
  description = "Zone visibility: 'private' for VPC internal resolution or 'public' for internet domain resolution."
  default     = "private"

  validation {
    condition     = contains(["private", "public"], var.visibility)
    error_message = "Visibility must be either 'private' or 'public'."
  }
}

variable "private_visibility_networks" {
  type        = list(string)
  description = "List of VPC Network self_links to associate with private DNS zone."
  default     = []
}

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number, 300)
    records = list(string)
  }))
  description = "Dynamic list of DNS record sets (A, AAAA, CNAME, TXT, MX) to populate in the zone."
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Map of resource labels. Must include 'environment' and 'managed_by'."
  default = {
    environment = "development"
    managed_by  = "terraform"
  }

  validation {
    condition     = contains(keys(var.labels), "environment") && contains(keys(var.labels), "managed_by")
    error_message = "The labels map must include both 'environment' and 'managed_by' keys."
  }
}
