variable "function_app_name" {
  description = "The name of the Function App."
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

variable "os_type" {
  description = "OS type: Linux or Windows."
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "Plan SKU: Y1 (Consumption), EP1 (Elastic Premium), B1, P1v3."
  type        = string
  default     = "Y1"
}

variable "service_plan_id" {
  description = "Optional existing Service Plan ID. If null, a plan will be created."
  type        = string
  default     = null
}

variable "storage_account_name" {
  description = "Name of the backend Storage Account."
  type        = string
}

variable "storage_account_access_key" {
  description = "Access key of the backend Storage Account (sensitive)."
  type        = string
  sensitive   = true
}

variable "application_insights_key" {
  description = "Application Insights Instrumentation Key."
  type        = string
  default     = null
}

variable "vnet_integration_subnet_id" {
  description = "Subnet ID for VNet integration."
  type        = string
  default     = null
}

variable "application_stack" {
  description = "Runtime application stack parameters."
  type = object({
    dotnet_version = optional(string)
    node_version   = optional(string)
    python_version = optional(string)
  })
  default = null
}

variable "app_settings" {
  description = "Application settings map."
  type        = map(string)
  default     = {}
}

variable "identity_type" {
  description = "Managed identity type."
  type        = string
  default     = "SystemAssigned"
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
