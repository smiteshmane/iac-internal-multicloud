variable "public_ip_name" {
  description = "The name of the Public IP."
  type        = string
}

variable "location" {
  description = "The Azure region for the Public IP."
  type        = string
}

variable "resource_group_name" {
  description = "The Resource Group name."
  type        = string
}

variable "allocation_method" {
  description = "Defines the allocation method for this IP address. Options: Static, Dynamic."
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the Public IP. Options: Basic, Standard."
  type        = string
  default     = "Standard"
}

variable "sku_tier" {
  description = "The SKU Tier of the Public IP. Options: Regional, Global."
  type        = string
  default     = "Regional"
}

variable "domain_name_label" {
  description = "Label for the Domain Name. Will be used to make the FQDN."
  type        = string
  default     = null
}

variable "idle_timeout_in_minutes" {
  description = "Specifies the timeout for the TCP idle connection in minutes."
  type        = number
  default     = 4
}

variable "zones" {
  description = "A collection of Availability Zones in which this Public IP should be allocated."
  type        = list(string)
  default     = ["1", "2", "3"]
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
