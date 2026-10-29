variable "vault_name" {
  description = "The name of the Recovery Services Vault."
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

variable "sku" {
  description = "SKU for the vault: Standard or RS0."
  type        = string
  default     = "Standard"
}

variable "storage_mode_type" {
  description = "Storage redundancy: GeoRedundant, LocallyRedundant, ZoneRedundant."
  type        = string
  default     = "GeoRedundant"
}

variable "soft_delete_enabled" {
  description = "Is soft delete enabled for backups?"
  type        = bool
  default     = true
}

variable "backup_policies" {
  description = "Map of VM Backup Policies: key=name, value={backup_frequency, backup_time, retention_daily_count, timezone}"
  type = map(object({
    backup_frequency      = string
    backup_time           = string
    retention_daily_count = optional(number, 7)
    timezone              = optional(string, "UTC")
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
