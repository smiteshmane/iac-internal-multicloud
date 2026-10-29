variable "instance_id" {
  type        = string
  description = "The unique instance ID for the MemoryStore Redis cluster."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,38}[a-z0-9]$", var.instance_id))
    error_message = "The instance_id must start with a letter, contain lowercase letters, numbers, or hyphens, up to 40 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Redis instance will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "region" {
  type        = string
  description = "The GCP region for the Redis instance."
  default     = "us-central1"
}

variable "tier" {
  type        = string
  description = "The service tier of the instance (BASIC or STANDARD_HA)."
  default     = "STANDARD_HA"

  validation {
    condition     = contains(["BASIC", "STANDARD_HA"], var.tier)
    error_message = "Tier must be either 'BASIC' or 'STANDARD_HA'."
  }
}

variable "memory_size_gb" {
  type        = number
  description = "Redis memory size in GiB."
  default     = 1
}

variable "redis_version" {
  type        = string
  description = "Version of Redis software (e.g. REDIS_6_X, REDIS_7_0)."
  default     = "REDIS_7_0"
}

variable "authorized_network" {
  type        = string
  description = "The full self_link of the VPC network to authorize for private IP peering."
  default     = null
}

variable "auth_enabled" {
  type        = bool
  description = "Whether Redis AUTH password authentication is enabled."
  default     = true
}

variable "transit_encryption_mode" {
  type        = string
  description = "TLS in-transit encryption mode (SERVER_AUTHENTICATION or DISABLED)."
  default     = "SERVER_AUTHENTICATION"

  validation {
    condition     = contains(["SERVER_AUTHENTICATION", "DISABLED"], var.transit_encryption_mode)
    error_message = "transit_encryption_mode must be 'SERVER_AUTHENTICATION' or 'DISABLED'."
  }
}

variable "redis_configs" {
  type        = map(string)
  description = "Map of custom Redis configuration parameters (e.g. maxmemory-policy)."
  default = {
    maxmemory-policy = "allkeys-lru"
  }
}

variable "labels" {
  type        = map(string)
  description = "Map of resource labels. Must include 'environment' and 'managed_by'."
  default = {
    environment = "development"
    managed_by  = "terraform"
  }

  validation {
    condition     = contains(keys(var.labels), "environment") && contains(keys(var.labels), "managed_by")
    error_message = "The labels map must include both 'environment' and 'managed_by' keys."
  }
}
