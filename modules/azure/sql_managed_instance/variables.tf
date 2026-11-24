variable "managed_instance_name" {
  description = "The name of the Azure SQL Managed Instance. Must be globally unique."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the SQL Managed Instance."
  type        = string
}

variable "location" {
  description = "The Azure region where the SQL Managed Instance should exist."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the delegated Subnet for this SQL Managed Instance."
  type        = string
}

variable "sku_name" {
  description = "Specifies the SKU Name for the SQL Managed Instance. Valid values include GP_Gen5, BC_Gen5."
  type        = string
  default     = "GP_Gen5"
}

variable "vcores" {
  description = "Number of cores that should be assigned to the SQL Managed Instance. Minimum is 4 for GP_Gen5."
  type        = number
  default     = 4
}

variable "storage_size_in_gb" {
  description = "Maximum storage size for the SQL Managed Instance in GB. Minimum is 32."
  type        = number
  default     = 32
}

variable "license_type" {
  description = "Specifies the license type applied for this Managed Instance. Possible values: LicenseIncluded, BasePrice."
  type        = string
  default     = "LicenseIncluded"
}

variable "administrator_login" {
  description = "The administrator login name for the new SQL Managed Instance."
  type        = string
  default     = "sqladmin"
}

variable "administrator_login_password" {
  description = "The password associated with the administrator_login for the new SQL Managed Instance."
  type        = string
  sensitive   = true
}

variable "minimum_tls_version" {
  description = "The Minimum TLS Version for the SQL Managed Instance. Possible values are 1.0, 1.1, and 1.2."
  type        = string
  default     = "1.2"
}

variable "proxy_override" {
  description = "Specifies how the SQL Managed Instance will be accessed. Possible values: Default, Proxy, Redirect."
  type        = string
  default     = "Redirect"
}

variable "public_data_endpoint_enabled" {
  description = "Is the public data endpoint enabled? Defaults to false."
  type        = bool
  default     = false
}

variable "storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database. Possible values: GRS, LRS, ZRS."
  type        = string
  default     = "LRS"
}

variable "timezone_id" {
  description = "The time zone of the SQL Managed Instance."
  type        = string
  default     = "UTC"
}

variable "identity_type" {
  description = "The type of identity used for the SQL Managed Instance (e.g. SystemAssigned, UserAssigned)."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "List of User Assigned Identity IDs if identity_type includes UserAssigned."
  type        = list(string)
  default     = null
}

variable "collation" {
  description = "The collation for the SQL Managed Instance."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "azuread_administrator" {
  description = "Azure Active Directory / Microsoft Entra Administrator block."
  type = object({
    login_username              = string
    object_id                   = string
    tenant_id                   = optional(string)
    azuread_authentication_only = optional(bool, false)
  })
  default = null
}

variable "database_names" {
  description = "List of optional managed database names to create on the instance."
  type        = list(string)
  default     = []
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
