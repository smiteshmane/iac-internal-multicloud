variable "action_group_name" {
  description = "The name of the Monitor Action Group."
  type        = string
}

variable "short_name" {
  description = "The short name of the Action Group (up to 12 chars)."
  type        = string
}

variable "resource_group_name" {
  description = "The Resource Group name."
  type        = string
}

variable "email_receivers" {
  description = "List of email receivers."
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "webhook_receivers" {
  description = "List of webhook receivers."
  type = list(object({
    name                    = string
    service_uri             = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "metric_alerts" {
  description = "Map of metric alert definitions."
  type = map(object({
    scopes           = list(string)
    description      = optional(string, "Metric alert rule")
    severity         = optional(number, 2)
    frequency        = optional(string, "PT1M")
    window_size      = optional(string, "PT5M")
    metric_namespace = string
    metric_name      = string
    aggregation      = string
    operator         = string
    threshold        = number
  }))
  default = {}
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
