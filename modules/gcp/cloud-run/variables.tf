variable "service_name" {
  type        = string
  description = "The name of the Cloud Run v2 service."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.service_name))
    error_message = "The service_name must start with a letter, contain lowercase letters, numbers, or hyphens, and be up to 63 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Cloud Run service will be deployed."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "location" {
  type        = string
  description = "The GCP region for the Cloud Run service."
  default     = "us-central1"
}

variable "container_image" {
  type        = string
  description = "GCR or Artifact Registry container image URI to deploy."
}

variable "container_port" {
  type        = number
  description = "Port on which the container listens."
  default     = 8080
}

variable "cpu_limit" {
  type        = string
  description = "CPU limit for the container (e.g. 1000m, 2000m)."
  default     = "1000m"
}

variable "memory_limit" {
  type        = string
  description = "Memory limit for the container (e.g. 512Mi, 1Gi, 2Gi)."
  default     = "512Mi"
}

variable "min_instances" {
  type        = number
  description = "Minimum number of serving container instances."
  default     = 0
}

variable "max_instances" {
  type        = number
  description = "Maximum number of serving container instances."
  default     = 100
}

variable "ingress_settings" {
  type        = string
  description = "Ingress traffic restriction (INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER)."
  default     = "INGRESS_TRAFFIC_ALL"

  validation {
    condition     = contains(["INGRESS_TRAFFIC_ALL", "INGRESS_TRAFFIC_INTERNAL_ONLY", "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"], var.ingress_settings)
    error_message = "Invalid ingress setting. Must be one of INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER."
  }
}

variable "env_vars" {
  type        = map(string)
  description = "Map of environment variables to expose in the container."
  default     = {}
}

variable "service_account_email" {
  type        = string
  description = "Service Account email under which the Cloud Run service executes."
  default     = null
}

variable "vpc_connector_name" {
  type        = string
  description = "VPC Access Connector self_link or name for internal VPC access."
  default     = null
}

variable "vpc_egress" {
  type        = string
  description = "VPC egress mode (ALL_TRAFFIC or PRIVATE_RANGES_ONLY)."
  default     = "PRIVATE_RANGES_ONLY"
}

variable "invokers" {
  type        = list(string)
  description = "List of IAM principal members granted roles/run.invoker (e.g. ['allUsers'] for public, or service accounts)."
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
