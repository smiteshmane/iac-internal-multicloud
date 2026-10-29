variable "lb_name" {
  description = "The name of the Load Balancer."
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
  description = "The SKU of the Load Balancer. Options: Basic, Standard."
  type        = string
  default     = "Standard"
}

variable "frontend_ip_name" {
  description = "The name of the frontend IP configuration."
  type        = string
  default     = "LoadBalancerFrontend"
}

variable "public_ip_address_id" {
  description = "ID of Public IP for a Public Load Balancer."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID for an Internal Load Balancer."
  type        = string
  default     = null
}

variable "private_ip_address" {
  description = "Static private IP address for Internal Load Balancer."
  type        = string
  default     = null
}

variable "private_ip_address_allocation" {
  description = "Private IP allocation method: Dynamic or Static."
  type        = string
  default     = "Dynamic"
}

variable "backend_pool_name" {
  description = "The name of the backend address pool."
  type        = string
  default     = "BackendAddressPool"
}

variable "probes" {
  description = "List of health probes to create."
  type = list(object({
    name         = string
    port         = number
    protocol     = optional(string, "Tcp")
    request_path = optional(string)
  }))
  default = []
}

variable "lb_rules" {
  description = "List of load balancing rules to create."
  type = list(object({
    name          = string
    protocol      = optional(string, "Tcp")
    frontend_port = number
    backend_port  = number
    probe_name    = optional(string)
  }))
  default = []
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
