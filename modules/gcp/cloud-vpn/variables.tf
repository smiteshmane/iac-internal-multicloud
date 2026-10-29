variable "name" {
  type        = string
  description = "The prefix name for HA Cloud VPN gateway and Cloud Router resources."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.name))
    error_message = "The name must start with a letter, contain lowercase letters, numbers, or hyphens, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the HA Cloud VPN Gateway will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "region" {
  type        = string
  description = "The GCP region for the HA VPN gateway."
  default     = "us-central1"
}

variable "network" {
  type        = string
  description = "The VPC network self_link or name where the HA VPN Gateway attaches."
}

variable "bgp_asn" {
  type        = number
  description = "BGP Autonomous System Number (ASN) for Cloud Router (64512-65534 or 4200000000-4294967294)."
  default     = 65000
}

variable "tunnels" {
  type = list(object({
    name                  = string
    peer_external_ip      = string
    shared_secret         = string
    vpn_gateway_interface = optional(number, 0)
  }))
  description = "Dynamic list of IPsec VPN tunnels to establish with peer gateways."
  default     = []
}
