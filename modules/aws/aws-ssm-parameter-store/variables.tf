variable "create" {
  description = "Controls whether SSM parameter resources should be created"
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
  description = "Name identifier for the SSM Parameter"
  type        = string
  default     = "config"
}

variable "name_prefix" {
  description = "Custom override for parameter name"
  type        = string
  default     = ""
}

variable "type" {
  description = "Type of the parameter (String, StringList, or SecureString)"
  type        = string
  default     = "SecureString"

  validation {
    condition     = contains(["String", "StringList", "SecureString"], var.type)
    error_message = "Parameter type must be String, StringList, or SecureString."
  }
}

variable "value" {
  description = "Value of the parameter"
  type        = string
  sensitive   = true
  default     = "dummy_value"
}

variable "description" {
  description = "Description of the parameter"
  type        = string
  default     = "Managed SSM Parameter"
}

variable "key_id" {
  description = "KMS key ID or ARN for SecureString parameters"
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
