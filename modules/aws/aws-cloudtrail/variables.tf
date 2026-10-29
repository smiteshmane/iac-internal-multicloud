variable "create" {
  description = "Controls whether CloudTrail resources should be created"
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
  description = "Name identifier for the CloudTrail"
  type        = string
  default     = "audit-trail"
}

variable "name_prefix" {
  description = "Custom override prefix for CloudTrail resource naming"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "Name of existing S3 bucket to store CloudTrail logs. If null, a new bucket will be created"
  type        = string
  default     = null
}

variable "create_s3_bucket" {
  description = "Controls whether to create a dedicated S3 bucket for CloudTrail logs"
  type        = bool
  default     = true
}

variable "s3_key_prefix" {
  description = "S3 key prefix for CloudTrail log objects"
  type        = string
  default     = "cloudtrail"
}

variable "is_multi_region_trail" {
  description = "Specifies whether the trail is created in the current region or in all regions"
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Specifies whether the trail is publishing events from global services such as IAM"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Specifies whether log file integrity validation is enabled"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS Key ARN used to encrypt CloudTrail log files"
  type        = string
  default     = null
}

variable "enable_logging" {
  description = "Enables logging for the trail"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logs" {
  description = "Specifies whether log events are sent to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Retention period for CloudWatch Log Group in days"
  type        = number
  default     = 90
}

variable "is_organization_trail" {
  description = "Specifies whether the trail is an AWS Organizations trail"
  type        = bool
  default     = false
}

variable "event_selectors" {
  description = "List of event selector configurations"
  type = list(object({
    read_write_type           = optional(string, "All")
    include_management_events = optional(bool, true)
    data_resources = optional(list(object({
      type   = string
      values = list(string)
    })), [])
  }))
  default = []
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
