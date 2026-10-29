variable "app_gateway_name" {
  description = "The name of the Application Gateway."
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

variable "sku_name" {
  description = "SKU Name: Standard_v2 or WAF_v2."
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "SKU Tier: Standard_v2 or WAF_v2."
  type        = string
  default     = "Standard_v2"
}

variable "capacity" {
  description = "Static instance capacity (1-125) if autoscale is disabled."
  type        = number
  default     = 2
}

variable "autoscale_configuration" {
  description = "Autoscale configuration block."
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}

variable "subnet_id" {
  description = "Dedicated Subnet ID for the Application Gateway."
  type        = string
}

variable "public_ip_id" {
  description = "Public IP ID for frontend IP configuration."
  type        = string
}

variable "backend_address_pool_name" {
  description = "Backend Address Pool name."
  type        = string
  default     = "appgw-backend-pool"
}

variable "backend_ip_addresses" {
  description = "List of backend IP addresses."
  type        = list(string)
  default     = []
}

variable "backend_fqdns" {
  description = "List of backend FQDNs."
  type        = list(string)
  default     = []
}

variable "backend_http_settings_name" {
  description = "Backend HTTP settings name."
  type        = string
  default     = "appgw-http-settings"
}

variable "backend_port" {
  description = "Backend target port."
  type        = number
  default     = 80
}

variable "backend_protocol" {
  description = "Backend protocol: Http or Https."
  type        = string
  default     = "Http"
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
