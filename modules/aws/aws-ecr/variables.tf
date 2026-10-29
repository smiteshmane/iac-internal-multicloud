variable "create" {
  description = "Controls whether ECR resources should be created"
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
  description = "Name identifier for the ECR repository"
  type        = string
  default     = "app-repo"
}

variable "name_prefix" {
  description = "Custom override prefix for repository naming"
  type        = string
  default     = ""
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Valid values: MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values: AES256 or KMS"
  type        = string
  default     = "KMS"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be either AES256 or KMS."
  }
}

variable "kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is KMS"
  type        = string
  default     = null
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "create_lifecycle_policy" {
  description = "Controls whether to create an ECR lifecycle policy"
  type        = bool
  default     = true
}

variable "max_untagged_image_age_days" {
  description = "Maximum age in days for untagged images before deletion"
  type        = number
  default     = 14
}

variable "max_tagged_image_count" {
  description = "Maximum number of tagged images to retain"
  type        = number
  default     = 30
}

variable "read_access_arns" {
  description = "List of IAM ARNs granted pull/read access to the ECR repository"
  type        = list(string)
  default     = []
}

variable "read_write_access_arns" {
  description = "List of IAM ARNs granted push/pull/write access to the ECR repository"
  type        = list(string)
  default     = []
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
