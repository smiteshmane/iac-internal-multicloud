variable "route_table_name" {
  description = "The name of the Route Table."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group."
  type        = string
}

variable "location" {
  description = "The Azure region where the Route Table will be created."
  type        = string
}

variable "bgp_route_propagation_enabled" {
  description = "Boolean flag which controls propagation of routes learned by BGP on that route table. True means enable."
  type        = bool
  default     = true
}

variable "routes" {
  description = "List of route objects to configure on the route table."
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = []
}

variable "subnet_id" {
  description = "The Subnet ID to associate with this Route Table (optional)."
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
