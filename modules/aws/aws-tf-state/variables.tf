variable "create" {
  description = "Controls whether remote state storage resources should be created"
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
  description = "Name identifier for the remote state backend resources"
  type        = string
  default     = "tf-state"
}

variable "name_prefix" {
  description = "Custom override prefix for naming"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Explicit name for the state S3 bucket. If null, auto-generated as <name_prefix>-bucket"
  type        = string
  default     = null
}

variable "dynamodb_table_name" {
  description = "Explicit name for the state locks DynamoDB table. If null, auto-generated as <name_prefix>-locks"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used for encrypting the S3 state bucket and DynamoDB lock table"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to allow destroying S3 bucket containing state files"
  type        = bool
  default     = false
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
