variable "create" {
  description = "Controls whether SNS/SQS resources should be created"
  type        = bool
  default     = true
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "enterprise"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "dev2", "qa", "uat", "prod", "sandbox", "staging"], var.environment)
    error_message = "Environment must be one of: dev, dev2, qa, uat, prod, sandbox, staging."
  }
}

variable "name" {
  description = "Name identifier for the SNS topic and SQS queue"
  type        = string
  default     = "events"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "enable_sns_topic" {
  description = "Create SNS Topic"
  type        = bool
  default     = true
}

variable "enable_sqs_queue" {
  description = "Create SQS Queue"
  type        = bool
  default     = true
}

variable "enable_dlq" {
  description = "Create Dead Letter Queue (DLQ) for SQS"
  type        = bool
  default     = true
}

variable "max_receive_count" {
  description = "Number of times a message can be received before being sent to DLQ"
  type        = number
  default     = 5
}

variable "subscribe_sqs_to_sns" {
  description = "Automatically subscribe SQS queue to SNS topic"
  type        = bool
  default     = true
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
