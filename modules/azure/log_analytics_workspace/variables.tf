variable "workspace_name" {
  description = "The name of the Log Analytics Workspace."
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
  description = "Specifies the SKU of the Log Analytics Workspace. Options: PerGB2018, Free, Standalone, CapacityReservation."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "The workspace data retention in days (30-730)."
  type        = number
  default     = 30
}

variable "daily_quota_gb" {
  description = "The workspace daily quota for ingestion in GB. -1 for unlimited."
  type        = number
  default     = -1
}

variable "solutions" {
  description = "Map of Log Analytics solution definitions: key=solution_name, value={publisher, product}"
  type = map(object({
    publisher = string
    product   = string
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
