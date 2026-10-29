variable "storage_account_name" {
  description = "The name of the Storage Account (3-24 alphanumeric lowercase characters)."
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

variable "account_tier" {
  description = "Tier: Standard or Premium."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
  default     = "GRS"
}

variable "account_kind" {
  description = "Kind of Storage Account: StorageV2, BlobStorage, BlockBlobStorage."
  type        = string
  default     = "StorageV2"
}

variable "public_network_access_enabled" {
  description = "Allow or disallow public network access."
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow public access to blobs or containers."
  type        = bool
  default     = false
}

variable "enable_blob_versioning" {
  description = "Is blob versioning enabled?"
  type        = bool
  default     = true
}

variable "blob_delete_retention_days" {
  description = "Retention days for soft-deleted blobs."
  type        = number
  default     = 7
}

variable "container_delete_retention_days" {
  description = "Retention days for soft-deleted containers."
  type        = number
  default     = 7
}

variable "network_rules" {
  description = "Network rules for restricting traffic to the Storage Account."
  type = object({
    default_action             = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
    bypass                     = optional(list(string), ["AzureServices"])
  })
  default = null
}

variable "containers" {
  description = "Map of containers to create: key=name, value={container_access_type='private'}"
  type        = map(map(string))
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
