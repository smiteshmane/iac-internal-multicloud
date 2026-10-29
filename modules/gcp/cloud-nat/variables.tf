variable "nat_name" {
  type        = string
  description = "The prefix name for Cloud Router and Cloud NAT Gateway."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.nat_name))
    error_message = "The nat_name must start with a letter, contain lowercase letters, numbers, or hyphens, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where Cloud NAT will be deployed."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "region" {
  type        = string
  description = "The GCP region where Cloud NAT Gateway will be deployed."
  default     = "us-central1"
}

variable "network" {
  type        = string
  description = "The VPC network self_link or name to attach Cloud NAT."
}

variable "num_static_ips" {
  type        = number
  description = "Number of static external IP addresses to reserve for NAT (0 for AUTO_ONLY)."
  default     = 0
}

variable "log_filter" {
  type        = string
  description = "Logging filter level (ERRORS_ONLY, TRANSLATIONS_ONLY, ALL)."
  default     = "ERRORS_ONLY"

  validation {
    condition     = contains(["ERRORS_ONLY", "TRANSLATIONS_ONLY", "ALL"], var.log_filter)
    error_message = "log_filter must be one of ERRORS_ONLY, TRANSLATIONS_ONLY, ALL."
  }
}
