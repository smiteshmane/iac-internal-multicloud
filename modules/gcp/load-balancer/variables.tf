variable "name" {
  type        = string
  description = "The prefix name for the load balancer resources."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.name))
    error_message = "The name must start with a letter, contain lowercase letters, numbers, or hyphens, and be up to 63 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Load Balancer will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "backends" {
  type = list(object({
    group = string
  }))
  description = "List of backend instance groups or network endpoint groups (NEGs)."
  default     = []
}

variable "health_check_port" {
  type        = number
  description = "Port used by HTTP health check."
  default     = 80
}

variable "health_check_request_path" {
  type        = string
  description = "HTTP health check request path."
  default     = "/healthz"
}

variable "enable_health_check" {
  type        = bool
  description = "Whether to create and attach a health check (set false when using Serverless NEGs)."
  default     = true
}

variable "enable_cloud_armor" {
  type        = bool
  description = "Whether to create and attach a Cloud Armor WAF security policy."
  default     = true
}

variable "blocked_ip_ranges" {
  type        = list(string)
  description = "List of IP ranges to block in Cloud Armor WAF security policy."
  default     = []
}

variable "ssl_certificates" {
  type        = list(string)
  description = "Optional list of SSL certificate self_links for HTTPS target proxy."
  default     = []
}
