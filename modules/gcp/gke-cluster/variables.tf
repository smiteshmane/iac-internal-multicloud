variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,38}[a-z0-9]$", var.cluster_name))
    error_message = "The cluster_name must start with a letter, contain only lowercase letters, numbers, or hyphens, and be up to 40 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID in which to create the cluster."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "region" {
  type        = string
  description = "The GCP region for the regional GKE cluster."
  default     = "us-central1"
}

variable "network" {
  type        = string
  description = "The VPC network self_link or name."
}

variable "subnetwork" {
  type        = string
  description = "The VPC subnetwork self_link or name."
}

variable "ip_allocation_policy" {
  type = object({
    cluster_secondary_range_name  = string
    services_secondary_range_name = string
  })
  description = "VPC Native IP allocation secondary range configuration for pods and services."
}

variable "enable_private_nodes" {
  type        = bool
  description = "Whether nodes have internal IP addresses only."
  default     = true
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Whether the master is accessible only through internal IP."
  default     = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The /28 CIDR block for GKE control plane master private network."
  default     = "172.16.0.0/28"
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "List of authorized CIDR blocks allowed to access GKE control plane."
  default     = []
}

variable "node_pools" {
  type = list(object({
    name         = string
    machine_type = optional(string, "e2-standard-4")
    min_count    = optional(number, 1)
    max_count    = optional(number, 5)
    disk_size_gb = optional(number, 100)
    disk_type    = optional(number, "pd-standard")
    spot         = optional(bool, false)
  }))
  description = "List of node pools configuration objects."
  default     = []
}

variable "deletion_protection" {
  type        = bool
  description = "Whether deletion protection is enabled on the cluster."
  default     = true
}

variable "labels" {
  type        = map(string)
  description = "Resource labels map. Must include 'environment' and 'managed_by'."
  default = {
    environment = "development"
    managed_by  = "terraform"
  }

  validation {
    condition     = contains(keys(var.labels), "environment") && contains(keys(var.labels), "managed_by")
    error_message = "The labels map must include both 'environment' and 'managed_by' keys."
  }
}
