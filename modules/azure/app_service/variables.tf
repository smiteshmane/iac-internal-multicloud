variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "app_service_name" {
  description = "The name of the Web App."
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
  description = "OS Type for App Service Plan: Linux or Windows."
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "SKU for App Service Plan (e.g. B1, P1v2, P1v3, S1)."
  type        = string
  default     = "P1v3"
}

variable "always_on" {
  description = "Keep the app loaded even when no traffic."
  type        = bool
  default     = true
}

variable "vnet_integration_subnet_id" {
  description = "Optional Subnet ID for VNet Integration."
  type        = string
  default     = null
}

variable "application_stack" {
  description = "Runtime application stack parameters."
  type = object({
    dotnet_version      = optional(string)
    node_version        = optional(string)
    python_version      = optional(string)
    docker_image_name   = optional(string)
    docker_registry_url = optional(string)
  })
  default = null
}

variable "app_settings" {
  description = "Key-value pairs for Application Settings."
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
