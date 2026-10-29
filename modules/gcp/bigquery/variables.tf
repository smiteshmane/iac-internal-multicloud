variable "dataset_id" {
  type        = string
  description = "A unique ID for the BigQuery dataset."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_]{1,1024}$", var.dataset_id))
    error_message = "The dataset_id must contain alphanumeric characters or underscores."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the BigQuery dataset will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "location" {
  type        = string
  description = "The regional or multi-regional location of the dataset (e.g. US, EU, us-central1)."
  default     = "US"
}

variable "description" {
  type        = string
  description = "User-specified description of the dataset."
  default     = "Production BigQuery dataset managed by Terraform."
}

variable "delete_contents_on_destroy" {
  type        = bool
  description = "Whether to force deletion of tables inside dataset when destroying."
  default     = false
}

variable "cmek_kms_key_name" {
  type        = string
  description = "Resource path of Cloud KMS Key for Customer-Managed Encryption Key (CMEK)."
  default     = null
}

variable "tables" {
  type = list(object({
    table_id                = string
    schema                  = string
    time_partitioning_field = optional(string)
    clustering              = optional(list(string), [])
    expiration_time         = optional(number)
  }))
  description = "Dynamic list of BigQuery table definitions."
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
