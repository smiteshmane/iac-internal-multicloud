variable "topic_name" {
  type        = string
  description = "The name of the Pub/Sub topic."

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9._~%+-]{2,254}$", var.topic_name))
    error_message = "The topic_name must start with a letter and be between 3 and 255 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Pub/Sub topic and subscriptions will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "cmek_kms_key_name" {
  type        = string
  description = "Resource path of Cloud KMS Key for Customer-Managed Encryption (CMEK)."
  default     = null
}

variable "subscriptions" {
  type = list(object({
    name                       = string
    ack_deadline_seconds       = optional(number, 20)
    retain_acked_messages      = optional(bool, false)
    message_retention_duration = optional(string, "604800s")
    enable_message_ordering    = optional(bool, false)
    filter                     = optional(string)
    push_endpoint              = optional(string)
    dead_letter_topic          = optional(string)
    max_delivery_attempts      = optional(number, 5)
  }))
  description = "Dynamic list of Pub/Sub subscriptions (pull/push/dead-letter) attached to the topic."
  default     = []
}

variable "publishers" {
  type        = list(string)
  description = "List of IAM principal members granted roles/pubsub.publisher on the topic."
  default     = []
}

variable "subscribers" {
  type        = list(string)
  description = "List of IAM principal members granted roles/pubsub.subscriber on the topic."
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
