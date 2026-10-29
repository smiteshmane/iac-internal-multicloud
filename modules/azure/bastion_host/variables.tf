variable "bastion_host_name" {
  description = "The name of the Bastion Host."
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

variable "azure_bastion_subnet_id" {
  description = "The ID of the subnet named 'AzureBastionSubnet'."
  type        = string
}

variable "public_ip_id" {
  description = "The ID of the Public IP address allocated for Azure Bastion."
  type        = string
}

variable "sku" {
  description = "SKU for Azure Bastion: Basic or Standard."
  type        = string
  default     = "Standard"
}

variable "scale_units" {
  description = "The number of scale units for Standard SKU Bastion (2-50)."
  type        = number
  default     = 2
}

variable "copy_paste_enabled" {
  description = "Is Copy/Paste enabled for Bastion session?"
  type        = bool
  default     = true
}

variable "file_copy_enabled" {
  description = "Is File Copy enabled (Standard SKU only)?"
  type        = bool
  default     = true
}

variable "tunneling_enabled" {
  description = "Is Native Client Tunneling enabled (Standard SKU only)?"
  type        = bool
  default     = true
}

variable "shareable_link_enabled" {
  description = "Is Shareable Link enabled (Standard SKU only)?"
  type        = bool
  default     = false
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
