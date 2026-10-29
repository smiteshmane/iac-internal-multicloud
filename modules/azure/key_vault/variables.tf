variable "key_vault_name" {
  description = "The name of the Key Vault (globally unique, 3-24 alphanumerics and hyphens)."
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
  description = "SKU: standard or premium."
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention period in days (7-90)."
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection to prevent early permanent deletion."
  type        = bool
  default     = true
}

variable "enable_rbac_authorization" {
  description = "Use Azure RBAC instead of Access Policies."
  type        = bool
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = "Allow VMs to retrieve certificates stored as secrets from the key vault."
  type        = bool
  default     = true
}

variable "network_acls" {
  description = "Network ACL configuration for Key Vault."
  type = object({
    bypass                     = optional(string, "AzureServices")
    default_action             = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = null
}

variable "secrets" {
  description = "Map of key/value pairs of secrets to store in Key Vault."
  type        = map(string)
  sensitive   = true
  default     = {}
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
