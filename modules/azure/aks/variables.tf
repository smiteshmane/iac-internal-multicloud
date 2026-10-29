variable "cluster_name" {
  description = "The name of the AKS Cluster."
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

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use."
  type        = string
  default     = null
}

variable "vnet_subnet_id" {
  description = "Subnet ID for AKS node pools (Azure CNI)."
  type        = string
  default     = null
}

variable "oidc_issuer_enabled" {
  description = "Enable OIDC issuer URL for Workload Identity."
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Enable Workload Identity integration."
  type        = bool
  default     = true
}

variable "network_plugin" {
  description = "Network plugin: azure or kubenet."
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy: calico or azure."
  type        = string
  default     = "azure"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for Container Insights."
  type        = string
  default     = null
}

variable "default_node_pool" {
  description = "Default node pool configuration."
  type = object({
    name                = optional(string, "system")
    node_count          = optional(number, 3)
    vm_size             = optional(string, "Standard_D4s_v5")
    enable_auto_scaling = optional(bool, true)
    min_count           = optional(number, 2)
    max_count           = optional(number, 5)
    os_disk_size_gb     = optional(number, 128)
  })
  default = {}
}

variable "additional_node_pools" {
  description = "Map of additional node pools."
  type = map(object({
    vm_size             = string
    node_count          = number
    enable_auto_scaling = optional(bool, false)
    min_count           = optional(number)
    max_count           = optional(number)
    mode                = optional(string, "User")
  }))
  default = {}
}

variable "identity_type" {
  description = "Identity type: SystemAssigned or UserAssigned."
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
