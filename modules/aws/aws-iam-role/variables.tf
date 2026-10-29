variable "create" {
  description = "Controls whether IAM role resources should be created"
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
  description = "Name identifier for the IAM Role"
  type        = string
  default     = "role"
}

variable "name_prefix" {
  description = "Custom override for IAM role name prefix"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Enterprise IAM Role"
}

variable "path" {
  description = "Path in which to create the IAM role"
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds (3600 to 43200)"
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the role"
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it"
  type        = bool
  default     = true
}

variable "trusted_role_services" {
  description = "AWS Service principal names that can assume this role (e.g. ['ec2.amazonaws.com', 'lambda.amazonaws.com'])"
  type        = list(string)
  default     = []
}

variable "trusted_role_arns" {
  description = "AWS ARNs (Accounts, Users, Roles) allowed to assume this role for cross-account access"
  type        = list(string)
  default     = []
}

variable "custom_trust_policy" {
  description = "Custom JSON policy document string overriding standard generated trust policy"
  type        = string
  default     = null
}

variable "oidc_providers" {
  description = "Map of OIDC provider configurations for federated authentication (e.g. EKS, GitHub Actions)"
  type = map(object({
    provider_arn = string
    issuer_url   = string
    audiences    = list(string)
    subjects     = list(string)
  }))
  default = {}
}

variable "managed_policy_arns" {
  description = "List of AWS or customer managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy names to policy JSON strings"
  type        = map(string)
  default     = {}
}

variable "create_instance_profile" {
  description = "Controls whether to create an IAM instance profile associated with this role"
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
