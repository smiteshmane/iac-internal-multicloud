variable "create" {
  description = "Controls whether Step Functions resources should be created"
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
  description = "Name identifier for the Step Functions State Machine"
  type        = string
  default     = "workflow"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "type" {
  description = "Determines whether a Standard or Express state machine is created (STANDARD or EXPRESS)"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.type)
    error_message = "Type must be STANDARD or EXPRESS."
  }
}

variable "definition" {
  description = "Amazon States Language (ASL) JSON definition of the state machine"
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
