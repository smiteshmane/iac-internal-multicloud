variable "subnet_name" {
  type        = string
  description = "The name of the VPC subnetwork."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,61}[a-z0-9]$", var.subnet_name))
    error_message = "The subnet_name must start with a letter, contain lowercase letters, numbers, or hyphens, and be up to 63 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the subnet will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "network" {
  type        = string
  description = "The self_link or name of the parent VPC network."
}

variable "region" {
  type        = string
  description = "The GCP region for the subnet."
  default     = "us-central1"
}

variable "ip_cidr_range" {
  type        = string
  description = "The primary IPv4 CIDR range for the subnet (e.g. 10.0.0.0/24)."

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}\\/[0-9]{1,2}$", var.ip_cidr_range))
    error_message = "The ip_cidr_range must be a valid IPv4 CIDR string (e.g. 10.0.0.0/24)."
  }
}

variable "private_ip_google_access" {
  type        = bool
  description = "Whether VMs in this subnet can access Google APIs without public IPs."
  default     = true
}

variable "secondary_ip_ranges" {
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  description = "Dynamic list of secondary IP ranges for GKE pods, services, or internal alias IPs."
  default     = []
}

variable "enable_flow_logs" {
  type        = bool
  description = "Whether to enable VPC Flow Logs for network traffic visibility."
  default     = false
}

variable "flow_logs_config" {
  type = object({
    aggregation_interval = optional(string, "INTERVAL_5_SEC")
    flow_sampling        = optional(number, 0.5)
    metadata             = optional(string, "INCLUDE_ALL_METADATA")
  })
  description = "Configuration block for VPC Flow Logs."
  default     = {}
}

variable "network_users" {
  type        = list(string)
  description = "List of IAM principal members granted roles/compute.networkUser on this subnet."
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
