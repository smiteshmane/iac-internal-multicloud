variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "location" {
  description = "The Azure region where the Virtual Network should exist."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the Virtual Network."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "List of IP addresses of DNS servers."
  type        = list(string)
  default     = []
}

variable "ddos_protection_plan_id" {
  description = "The ID of the DDoS Protection Plan to associate with the VNet."
  type        = string
  default     = null
}

variable "environment" {
  description = "Deployment environment (e.g. dev, test, prod)."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
