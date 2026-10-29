variable "vmss_name" {
  description = "The name of the Virtual Machine Scale Set."
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
  description = "The SKU size of the Virtual Machines in the Scale Set."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "instances" {
  description = "Initial capacity / instance count of the Scale Set."
  type        = number
  default     = 2
}

variable "subnet_id" {
  description = "The Subnet ID in which to place the Scale Set instances."
  type        = string
}

variable "load_balancer_backend_address_pool_ids" {
  description = "Optional list of Load Balancer Backend Address Pool IDs."
  type        = list(string)
  default     = []
}

variable "admin_username" {
  description = "The admin username for instances."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password (sensitive)."
  type        = string
  sensitive   = true
  default     = null
}

variable "disable_password_authentication" {
  description = "Enforce SSH key authentication."
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH public key string."
  type        = string
  default     = null
}

variable "storage_account_type" {
  description = "OS disk storage type: Premium_LRS, StandardSSD_LRS."
  type        = string
  default     = "Premium_LRS"
}

variable "image_publisher" {
  description = "Image publisher."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Image offer."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "Image SKU."
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "Image version."
  type        = string
  default     = "latest"
}

variable "identity_type" {
  description = "Identity type."
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
