variable "create" {
  description = "Controls whether Secrets Manager resources should be created"
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
  description = "Name identifier for the secret"
  type        = string
  default     = "app-secret"
}

variable "name_prefix" {
  description = "Custom override prefix for secret naming"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = "Managed Enterprise Secret"
}

variable "kms_key_id" {
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret (0 or 7 to 30)"
  type        = number
  default     = 30
}

variable "secret_string" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_key_value" {
  description = "Specifies key-value map data that will be JSON encoded and stored as secret_string"
  type        = map(string)
  default     = null
  sensitive   = true
}

variable "enable_rotation" {
  description = "Specifies whether automatic rotation is enabled for this secret"
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "Specifies the ARN of the Lambda function that can rotate the secret"
  type        = string
  default     = null
}

variable "automatically_after_days" {
  description = "Specifies the number of days between automatic scheduled rotations"
  type        = number
  default     = 30
}

variable "cross_account_roles" {
  description = "List of IAM Role ARNs from other AWS accounts granted read access to this secret"
  type        = list(string)
  default     = []
}

variable "policy" {
  description = "Valid JSON document representing resource policy"
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
