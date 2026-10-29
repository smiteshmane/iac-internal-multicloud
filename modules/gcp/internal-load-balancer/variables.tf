variable "name" {
  type        = string
  description = "The prefix name for internal load balancer resources."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.name))
    error_message = "The name must start with a letter, contain lowercase letters, numbers, or hyphens, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Internal Load Balancer will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "region" {
  type        = string
  description = "The GCP region for the internal load balancer."
  default     = "us-central1"
}

variable "network" {
  type        = string
  description = "The VPC network self_link or name."
}

variable "subnetwork" {
  type        = string
  description = "The VPC subnetwork self_link or name where internal static IP will be assigned."
}

variable "ports" {
  type        = list(string)
  description = "List of ports to forward (e.g. ['80', '8080'])."
  default     = ["80"]
}

variable "backends" {
  type = list(object({
    group = string
  }))
  description = "List of regional instance group backends."
  default     = []
}

variable "health_check_port" {
  type        = number
  description = "Port for TCP/HTTP health check."
  default     = 80
}

variable "ip_address" {
  type        = string
  description = "Optional static internal IP address within subnetwork CIDR. If null, automatically assigned."
  default     = null
}
