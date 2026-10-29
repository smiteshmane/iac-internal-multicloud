variable "sql_server_name" {
  description = "The name of the Azure SQL Server (globally unique)."
  type        = string
}

variable "database_name" {
  description = "The name of the Azure SQL Database."
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

variable "server_version" {
  description = "SQL Server version."
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "The administrator login name for the SQL Server."
  type        = string
  default     = "sqladmin"
}

variable "administrator_login_password" {
  description = "The administrator login password (sensitive). Recommended from Key Vault."
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "Database SKU name (e.g. Basic, Standard, S0, S1, GP_Gen5_2, BC_Gen5_2)."
  type        = string
  default     = "S0"
}

variable "max_size_gb" {
  description = "Maximum size of the database in GB."
  type        = number
  default     = 10
}

variable "collation" {
  description = "Collation setting for the SQL database."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "azuread_administrator" {
  description = "Azure Active Directory administrator configuration."
  type = object({
    login_username              = string
    object_id                   = string
    azuread_authentication_only = optional(bool, false)
  })
  default = null
}

variable "firewall_rules" {
  description = "Map of firewall rules to create: key=name, value={start_ip_address, end_ip_address}."
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
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
