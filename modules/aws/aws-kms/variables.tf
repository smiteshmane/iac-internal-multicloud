variable "create" {
  description = "Controls whether KMS key resources should be created"
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
  description = "Name identifier for the KMS Key"
  type        = string
  default     = "key"
}

variable "name_prefix" {
  description = "Custom override for KMS key alias/name prefix"
  type        = string
  default     = ""
}

variable "description" {
  description = "The description of the KMS key as viewed in AWS console"
  type        = string
  default     = "Customer Managed KMS Key"
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction (7 to 30)"
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30 days."
  }
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to true for enterprise security"
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "Specifies whether the key is enabled"
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key"
  type        = bool
  default     = false
}

variable "key_usage" {
  description = "Intended use of the key. Valid values: ENCRYPT_DECRYPT, SIGN_VERIFY, GENERATE_VERIFY_MAC"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "alias_name" {
  description = "Custom KMS Key Alias. If left blank, alias will be automatically created as alias/<name_prefix>"
  type        = string
  default     = ""
}

variable "key_owners" {
  description = "List of IAM ARNs granted full key administration capabilities"
  type        = list(string)
  default     = []
}

variable "key_users" {
  description = "List of IAM ARNs granted cryptographic usage permissions (Encrypt/Decrypt/GenerateDataKey)"
  type        = list(string)
  default     = []
}

variable "key_service_principals" {
  description = "List of AWS Service Principal identifiers granted key usage (e.g. s3.amazonaws.com, logs.amazonaws.com)"
  type        = list(string)
  default     = []
}

variable "custom_key_policy" {
  description = "Raw JSON policy document to override standard policy generation"
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
