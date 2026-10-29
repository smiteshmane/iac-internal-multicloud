variable "create" {
  description = "Controls whether Route53 resources should be created"
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

variable "domain_name" {
  description = "Domain name for the Route 53 hosted zone"
  type        = string
}

variable "private_zone" {
  description = "Create a private hosted zone"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID for private hosted zone association"
  type        = string
  default     = null
}

variable "records" {
  description = "List of DNS record definitions"
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number, 300)
    records = optional(list(string), [])
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, true)
    }), null)
  }))
  default = []
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
