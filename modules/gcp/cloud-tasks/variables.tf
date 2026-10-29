variable "queue_name" {
  type        = string
  description = "The name of the Cloud Tasks queue."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.queue_name))
    error_message = "The queue_name must start with a letter, contain lowercase letters, numbers, or hyphens, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Cloud Tasks queue will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "location" {
  type        = string
  description = "The GCP region for the Cloud Tasks queue."
  default     = "us-central1"
}

variable "max_dispatches_per_second" {
  type        = number
  description = "Maximum rate at which tasks are dispatched from the queue."
  default     = 500
}

variable "max_concurrent_dispatches" {
  type        = number
  description = "Maximum number of concurrent tasks executing from this queue."
  default     = 100
}

variable "max_attempts" {
  type        = number
  description = "Maximum number of retry attempts for a failed task (-1 for unlimited)."
  default     = 10
}

variable "min_backoff_sec" {
  type        = number
  description = "Minimum retry backoff interval in seconds."
  default     = 0.1
}

variable "max_backoff_sec" {
  type        = number
  description = "Maximum retry backoff interval in seconds."
  default     = 3600
}

variable "queue_enqueuers" {
  type        = list(string)
  description = "List of IAM principal members granted roles/cloudtasks.enqueuer on the queue."
  default     = []
}
