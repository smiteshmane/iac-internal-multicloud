variable "name" {
  type        = string
  description = "The name of the Cloud Scheduler cron job."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.name))
    error_message = "The name must start with a letter, contain lowercase letters, numbers, or hyphens, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Cloud Scheduler job will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "region" {
  type        = string
  description = "The GCP region for Cloud Scheduler."
  default     = "us-central1"
}

variable "schedule" {
  type        = string
  description = "Cron schedule expression (e.g. '0 * * * *' for hourly, '0 9 * * 1-5' for weekdays at 9am)."

  validation {
    condition     = can(regex("^.+ .+ .+ .+ .+$", var.schedule))
    error_message = "The schedule must be a valid 5-field cron expression."
  }
}

variable "time_zone" {
  type        = string
  description = "Specifies the time zone for the schedule (e.g. UTC, America/New_York)."
  default     = "UTC"
}

variable "description" {
  type        = string
  description = "Textual description of the cron job."
  default     = "Managed Cloud Scheduler cron job created by Terraform."
}

variable "http_target" {
  type = object({
    uri         = string
    http_method = optional(string, "POST")
    body        = optional(string)
    headers     = optional(map(string), {})
    oidc_token = optional(object({
      service_account_email = string
      audience              = optional(string)
    }))
  })
  description = "HTTP target configuration block."
  default     = null
}
