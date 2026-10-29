variable "instance_name" {
  type        = string
  description = "The name of the Cloud Spanner instance."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,61}[a-z0-9]$", var.instance_name))
    error_message = "The instance_name must start with a letter, contain lowercase letters, numbers, or hyphens, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where Cloud Spanner will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "config" {
  type        = string
  description = "The name of the instance's configuration (e.g. regional-us-central1, nam3)."
  default     = "regional-us-central1"
}

variable "display_name" {
  type        = string
  description = "Descriptive display name for the Spanner instance."
  default     = "Production Cloud Spanner Instance"
}

variable "processing_units" {
  type        = number
  description = "The number of processing units allocated to the instance (multiples of 100, e.g. 100, 500, 1000)."
  default     = 100
}

variable "databases" {
  type = list(object({
    name = string
    ddl  = optional(list(string), [])
  }))
  description = "Dynamic list of Cloud Spanner databases and DDL schemas to create."
  default     = []
}

variable "database_users" {
  type        = list(string)
  description = "List of IAM principal members granted roles/spanner.databaseUser."
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
