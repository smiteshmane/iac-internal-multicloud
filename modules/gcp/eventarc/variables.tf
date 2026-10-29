variable "name" {
  type        = string
  description = "The name of the Eventarc trigger."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.name))
    error_message = "The name must start with a letter, contain lowercase letters, numbers, or hyphens, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Eventarc trigger will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "location" {
  type        = string
  description = "The GCP region for the Eventarc trigger (or global)."
  default     = "us-central1"
}

variable "matching_criteria" {
  type = list(object({
    attribute = string
    value     = string
  }))
  description = "Dynamic list of event filter matching criteria (e.g. attribute='type', value='google.cloud.storage.object.v1.finalized')."
}

variable "cloud_run_service" {
  type        = string
  description = "Name of the target Cloud Run service to receive events."
}

variable "cloud_run_path" {
  type        = string
  description = "Optional HTTP path on the target Cloud Run service (e.g. /events)."
  default     = "/"
}

variable "service_account_email" {
  type        = string
  description = "The Service Account email attached to Eventarc trigger for invoking destination."
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
