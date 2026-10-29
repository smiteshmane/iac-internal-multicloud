variable "create" {
  description = "Controls whether ElastiCache resources should be created"
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
  description = "Name identifier for the Redis replication group"
  type        = string
  default     = "redis"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "node_type" {
  description = "Compute and memory capacity of the nodes (e.g. cache.t4g.micro, cache.m6g.large)"
  type        = string
  default     = "cache.t4g.micro"
}

variable "num_cache_clusters" {
  description = "Number of cache clusters (primary + replicas) in the replication group"
  type        = number
  default     = 1
}

variable "engine_version" {
  description = "Version number of the Redis engine"
  type        = string
  default     = "7.0"
}

variable "port" {
  description = "Port number on which each node accepts connections"
  type        = number
  default     = 6379
}

variable "subnet_ids" {
  description = "List of VPC Subnet IDs for ElastiCache Subnet Group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of Security Group IDs for ElastiCache network access"
  type        = list(string)
}

variable "transit_encryption_enabled" {
  description = "Enable TLS transit encryption"
  type        = bool
  default     = true
}

variable "at_rest_encryption_enabled" {
  description = "Enable at-rest encryption"
  type        = bool
  default     = true
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover for Multi-AZ deployments"
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
