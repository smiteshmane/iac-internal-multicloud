variable "create" {
  description = "Controls whether S3 bucket resources should be created"
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
  description = "Name identifier for the S3 bucket"
  type        = string
  default     = "bucket"
}

variable "name_prefix" {
  description = "Custom override prefix for S3 bucket name"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Explicit name for the bucket. If provided, overrides project-environment-name pattern"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "versioning_status" {
  description = "State of bucket versioning. Valid values: Enabled, Suspended, Disabled"
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning_status)
    error_message = "versioning_status must be one of: Enabled, Suspended, Disabled."
  }
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm. Valid values: aws:kms or AES256"
  type        = string
  default     = "aws:kms"

  validation {
    condition     = contains(["aws:kms", "AES256"], var.sse_algorithm)
    error_message = "sse_algorithm must be either 'aws:kms' or 'AES256'."
  }
}

variable "kms_master_key_arn" {
  description = "AWS KMS master key ARN for SSE-KMS encryption"
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Whether AWS uses an S3 Bucket Key for SSE-KMS"
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "logging_target_bucket" {
  description = "Target bucket for S3 access logging"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefix for S3 access log objects"
  type        = string
  default     = "logs/"
}

variable "lifecycle_rules" {
  description = "List of maps containing lifecycle configuration rules"
  type = list(object({
    id      = string
    enabled = bool
    prefix  = optional(string, null)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    expiration_days = optional(number, null)
    noncurrent_version_transitions = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })), [])
    noncurrent_version_expiration_days = optional(number, null)
  }))
  default = []
}

variable "attach_policy" {
  description = "Controls if an S3 bucket policy should be attached"
  type        = bool
  default     = false
}

variable "custom_bucket_policy" {
  description = "JSON text of the S3 bucket policy"
  type        = string
  default     = null
}

variable "enforce_tls" {
  description = "Enforce SSL/TLS for all S3 requests via bucket policy"
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
