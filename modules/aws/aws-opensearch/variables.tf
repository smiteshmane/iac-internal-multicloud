variable "create" {
  description = "Controls whether OpenSearch resources should be created"
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
  description = "Name identifier for the OpenSearch Domain"
  type        = string
  default     = "search"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "Version of OpenSearch or Elasticsearch engine"
  type        = string
  default     = "OpenSearch_2.11"
}

variable "instance_type" {
  description = "Instance type of data nodes in the cluster"
  type        = string
  default     = "t3.small.search"
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 1
}

variable "volume_size" {
  description = "Size of EBS volumes attached to data nodes (in GB)"
  type        = number
  default     = 20
}

variable "subnet_ids" {
  description = "List of VPC Subnet IDs for VPC-enabled OpenSearch domain"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of Security Group IDs for VPC-enabled OpenSearch domain"
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
