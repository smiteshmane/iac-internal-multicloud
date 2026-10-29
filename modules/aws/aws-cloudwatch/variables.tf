variable "create" {
  description = "Controls whether CloudWatch resources should be created"
  type        = bool
  default     = true
}

variable "project" {
  description = "Project name to be used for tag and resource naming conventions"
  type        = string
  default     = "enterprise"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment (e.g. dev, qa, uat, prod, sandbox, staging)"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "uat", "prod", "sandbox", "staging"], var.environment)
    error_message = "Environment must be one of: dev, qa, uat, prod, sandbox, staging."
  }
}

variable "name" {
  description = "Name identifier for CloudWatch resources"
  type        = string
  default     = "monitoring"
}

variable "name_prefix" {
  description = "Custom override prefix for naming"
  type        = string
  default     = ""
}

variable "create_log_group" {
  description = "Controls whether to create a CloudWatch Log Group"
  type        = bool
  default     = true
}

variable "log_group_name" {
  description = "Explicit name for the log group. If omitted, defaults to /aws/app/<name_prefix>"
  type        = string
  default     = null
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 90
}

variable "kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "create_sns_topic" {
  description = "Controls whether to create an SNS topic for alarm notifications"
  type        = bool
  default     = true
}

variable "sns_subscriptions" {
  description = "Map of SNS topic subscription definitions"
  type = map(object({
    protocol = string
    endpoint = string
  }))
  default = {}
}

variable "metric_alarms" {
  description = "Map of CloudWatch metric alarm configurations"
  type = map(object({
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_description   = optional(string, "CloudWatch Metric Alarm")
    dimensions          = optional(map(string), {})
  }))
  default = {}
}

variable "composite_alarms" {
  description = "Map of CloudWatch composite alarm configurations"
  type = map(object({
    alarm_rule        = string
    alarm_description = optional(string, "CloudWatch Composite Alarm")
  }))
  default = {}
}

variable "create_dashboard" {
  description = "Controls whether to create a CloudWatch Dashboard"
  type        = bool
  default     = false
}

variable "dashboard_body" {
  description = "Valid JSON string defining the CloudWatch dashboard structure"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional specific tags to merge with common tags"
  type        = map(string)
  default     = {}
}
