variable "create" {
  description = "Controls whether CloudFront resources should be created"
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
  description = "Name identifier for the CloudFront distribution"
  type        = string
  default     = "cdn"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "origin_domain_name" {
  description = "DNS domain name of the origin (e.g. S3 bucket domain name or ALB domain name)"
  type        = string
}

variable "origin_id" {
  description = "Unique identifier for the origin"
  type        = string
  default     = "CustomOrigin"
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end-user requests"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "Object that you want CloudFront to return when an end user requests the root URL"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Price class for this distribution (PriceClass_All, PriceClass_200, PriceClass_100)"
  type        = string
  default     = "PriceClass_100"
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
