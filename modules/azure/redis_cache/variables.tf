variable "redis_name" {
  description = "The name of the Redis Cache instance."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "The Resource Group name."
  type        = string
}

variable "sku_name" {
  description = "SKU: Basic, Standard, Premium."
  type        = string
  default     = "Standard"
}

variable "family" {
  description = "Family: C (Basic/Standard) or P (Premium)."
  type        = string
  default     = "C"
}

variable "capacity" {
  description = "Capacity level: 0-6 for Basic/Standard, 1-4 for Premium."
  type        = number
  default     = 1
}

variable "enable_non_ssl_port" {
  description = "Enable or disable the non-SSL port (6379)."
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "Subnet ID for VNet injection (Premium SKU only)."
  type        = string
  default     = null
}

variable "maxmemory_reserved" {
  description = "The value in megabytes reserved for non-cache processes (Standard/Premium)."
  type        = number
  default     = null
}

variable "maxmemory_delta" {
  description = "The maxmemory delta setting in MB."
  type        = number
  default     = null
}

variable "maxmemory_policy" {
  description = "Eviction policy for maxmemory: volatile-lru, allkeys-lru, noeviction, etc."
  type        = string
  default     = "allkeys-lru"
}

variable "firewall_rules" {
  description = "Map of Redis firewall rules: key=name, value={start_ip, end_ip}."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
