variable "create" {
  description = "Controls whether WAFv2 resources should be created"
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
  description = "Name identifier for the WAFv2 Web ACL"
  type        = string
  default     = "waf"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution (CLOUDFRONT) or for a regional application (REGIONAL)"
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "Scope must be either REGIONAL or CLOUDFRONT."
  }
}

variable "description" {
  description = "Description of the WAFv2 Web ACL"
  type        = string
  default     = "Managed WAFv2 Web ACL for application protection"
}

variable "enable_common_rule_set" {
  description = "Enable AWS Managed Rules Common Rule Set"
  type        = bool
  default     = true
}

variable "enable_known_bad_inputs_rule_set" {
  description = "Enable AWS Managed Rules Known Bad Inputs Rule Set"
  type        = bool
  default     = true
}

variable "enable_sqli_rule_set" {
  description = "Enable AWS Managed Rules SQL Database Rule Set"
  type        = bool
  default     = true
}

variable "enable_rate_limit_rule" {
  description = "Enable Rate Limiting Rule"
  type        = bool
  default     = true
}

variable "rate_limit" {
  description = "Rate limit threshold per 5 minutes per IP"
  type        = number
  default     = 2000
}

variable "associated_resource_arns" {
  description = "List of Regional AWS Resource ARNs (e.g. ALB ARNs) to associate with this Web ACL"
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
