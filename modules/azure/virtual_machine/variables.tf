variable "vm_name" {
  description = "The name of the Virtual Machine."
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
  description = "The OS type of the Virtual Machine: Linux or Windows."
  type        = string
  default     = "Linux"
}

variable "vm_size" {
  description = "The SKU / size of the Virtual Machine."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "subnet_id" {
  description = "The Subnet ID to attach the VM network interface."
  type        = string
}

variable "private_ip_address_allocation" {
  description = "Private IP allocation: Dynamic or Static."
  type        = string
  default     = "Dynamic"
}

variable "private_ip_address" {
  description = "Static private IP address if allocation is Static."
  type        = string
  default     = null
}

variable "public_ip_address_id" {
  description = "Optional Public IP ID to attach to the NIC."
  type        = string
  default     = null
}

variable "admin_username" {
  description = "The admin username for the VM."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the VM (sensitive). Recommended to reference from Key Vault."
  type        = string
  sensitive   = true
  default     = null
}

variable "disable_password_authentication" {
  description = "Should SSH key authentication be enforced for Linux VM?"
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH Public Key string for Linux VM authentication."
  type        = string
  default     = null
}

variable "os_disk_caching" {
  description = "Caching option for OS disk: ReadWrite, ReadOnly, None."
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Storage type for OS disk: Premium_LRS, StandardSSD_LRS, Standard_LRS."
  type        = string
  default     = "Premium_LRS"
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB."
  type        = number
  default     = 64
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
  description = "Managed identity type: SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned."
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
