variable "create" {
  description = "Controls whether EventBridge resources should be created"
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
  description = "Name identifier for the EventBus and Event Rules"
  type        = string
  default     = "bus"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "create_event_bus" {
  description = "Controls whether a custom EventBus should be created"
  type        = bool
  default     = true
}

variable "schedule_expression" {
  description = "Scheduling expression for periodic rule (e.g., rate(5 minutes) or cron(0 20 * * ? *))"
  type        = string
  default     = null
}

variable "event_pattern" {
  description = "Event pattern JSON for matching incoming events"
  type        = string
  default     = null
}

variable "target_arn" {
  description = "ARN of the target resource (e.g. Lambda, SQS, SNS, ECS task)"
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
