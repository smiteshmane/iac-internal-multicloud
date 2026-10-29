variable "network_name" {
  type        = string
  description = "The name of the custom VPC network."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,61}[a-z0-9]$", var.network_name))
    error_message = "The network_name must start with a letter, contain only lowercase letters, numbers, or hyphens, and be up to 63 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the VPC network will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "routing_mode" {
  type        = string
  description = "Network routing mode (GLOBAL or REGIONAL)."
  default     = "GLOBAL"

  validation {
    condition     = contains(["GLOBAL", "REGIONAL"], var.routing_mode)
    error_message = "The routing_mode must be either 'GLOBAL' or 'REGIONAL'."
  }
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "Whether to auto-create subnetworks in all regions."
  default     = false
}

variable "delete_default_routes_on_create" {
  type        = bool
  description = "Whether to delete default internet gateway route on network creation."
  default     = false
}

variable "subnets" {
  type = list(object({
    name                     = string
    region                   = string
    ip_cidr_range            = string
    private_ip_google_access = optional(bool, true)
    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
  description = "List of subnets with primary and secondary CIDR ranges."
  default     = []
}

variable "enable_cloud_nat" {
  type        = bool
  description = "Whether to provision a Cloud NAT router for outbound internet access from private subnets."
  default     = true
}

variable "nat_region" {
  type        = string
  description = "The GCP region to deploy Cloud Router & NAT."
  default     = "us-central1"
}

variable "allow_iap_ssh" {
  type        = bool
  description = "Dynamic boolean flag (true/false) to enable or disable creating the GCP Console IAP SSH firewall rule."
  default     = true
}

variable "iap_source_ranges" {
  type        = list(string)
  description = "Source IP ranges for GCP Console Identity-Aware Proxy (IAP)."
  default     = ["35.235.240.0/20"]
}

variable "custom_firewall_rules" {
  type = list(object({
    name          = string
    direction     = optional(string, "INGRESS")
    priority      = optional(number, 1000)
    source_ranges = optional(list(string), [])
    target_tags   = optional(list(string), [])
    allow = list(object({
      protocol = string
      ports    = optional(list(string), [])
    }))
  }))
  description = "Dynamic list of custom firewall rules to create in the VPC network."
  default     = []
}
