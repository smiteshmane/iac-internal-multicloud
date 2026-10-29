variable "secret_id" {
  type        = string
  description = "The unique secret ID name."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,255}$", var.secret_id))
    error_message = "The secret_id must contain alphanumeric characters, hyphens, or underscores, and be up to 255 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Secret will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "secret_data" {
  type        = string
  description = "Optional initial secret payload string to populate as the first secret version."
  default     = null
  sensitive   = true
}

variable "replication_locations" {
  type        = list(string)
  description = "List of GCP regions for user-managed replication. If empty, automatic replication is used."
  default     = []
}

variable "cmek_kms_key_name" {
  type        = string
  description = "Optional Cloud KMS Key resource path for CMEK secret payload encryption."
  default     = null
}

variable "expire_time" {
  type        = string
  description = "Optional RFC3339 timestamp for when the secret should automatically expire."
  default     = null
}

variable "rotation_period" {
  type        = string
  description = "Optional rotation period in seconds followed by 's' (e.g. 2592000s for 30 days)."
  default     = null
}

variable "secret_accessors" {
  type        = list(string)
  description = "List of IAM principal members granted roles/secretmanager.secretAccessor."
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
