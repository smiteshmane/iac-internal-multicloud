variable "subnet_name" {
  description = "The name of the Subnet."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the Subnet."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the Virtual Network in which to create the Subnet."
  type        = string
}

variable "address_prefixes" {
  description = "The address prefixes to use for the Subnet."
  type        = list(string)
}

variable "service_endpoints" {
  description = "The list of Service Endpoints to associate with the Subnet."
  type        = list(string)
  default     = []
}

variable "private_endpoint_network_policies_enabled" {
  description = "Enable or disable network policies for private endpoints on the Subnet."
  type        = bool
  default     = true
}

variable "private_link_service_network_policies_enabled" {
  description = "Enable or disable network policies for private link service on the Subnet."
  type        = bool
  default     = true
}

variable "delegations" {
  description = "List of delegation configurations for the Subnet."
  type = list(object({
    name         = string
    service_name = string
    actions      = list(string)
  }))
  default = []
}
