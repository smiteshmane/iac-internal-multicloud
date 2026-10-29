variable "create" {
  description = "Controls whether Lambda resources should be created"
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
  description = "Name identifier for the Lambda function"
  type        = string
  default     = "function"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = "Managed AWS Lambda Function"
}

variable "runtime" {
  description = "Lambda execution runtime (e.g. python3.12, nodejs20.x)"
  type        = string
  default     = "python3.12"
}

variable "handler" {
  description = "Function entrypoint handler"
  type        = string
  default     = "index.handler"
}

variable "memory_size" {
  description = "Amount of memory in MB allocated to the Lambda function"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Function execution timeout in seconds"
  type        = number
  default     = 30
}

variable "environment_variables" {
  description = "Map of environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "List of VPC Subnet IDs for VPC-enabled Lambda"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of VPC Security Group IDs for VPC-enabled Lambda"
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "CloudWatch log group retention period in days"
  type        = number
  default     = 30
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
