variable "project_id" {
  type        = string
  description = "The GCP project ID where Cloud Monitoring alert policies will be deployed."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "notification_email_addresses" {
  type        = list(string)
  description = "List of email addresses for alert notification channels."
  default     = []
}

variable "cpu_alert_threshold_percent" {
  type        = number
  description = "VM CPU utilization percentage threshold to trigger alert (e.g. 80 for 80%)."
  default     = 80
}

variable "enable_cpu_alert" {
  type        = bool
  description = "Whether to create high CPU utilization alert policy."
  default     = true
}

variable "alert_policies" {
  type = list(object({
    display_name         = string
    combiner             = optional(string, "OR")
    filter               = string
    duration             = optional(string, "300s")
    comparison           = optional(string, "COMPARISON_GT")
    threshold_value      = number
    alignment_period     = optional(string, "60s")
    per_series_aligner   = optional(string, "ALIGN_MEAN")
    cross_series_reducer = optional(string, "REDUCE_NONE")
  }))
  description = "Dynamic list of custom threshold alert policies."
  default     = []
}

variable "user_labels" {
  type        = map(string)
  description = "Map of user labels to attach to alert policies."
  default     = {}
}
