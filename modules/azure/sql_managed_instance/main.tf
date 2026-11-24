# Azure SQL Managed Instance Module
# Creates an Azure SQL Managed Instance with dedicated networking, storage, Entra ID / SQL authentication, and security configurations.

resource "azurerm_mssql_managed_instance" "this" {
  name                         = var.managed_instance_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  subnet_id                    = var.subnet_id
  sku_name                     = var.sku_name
  vcores                       = var.vcores
  storage_size_in_gb           = var.storage_size_in_gb
  license_type                 = var.license_type
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = var.minimum_tls_version
  proxy_override               = var.proxy_override
  public_data_endpoint_enabled = var.public_data_endpoint_enabled
  storage_account_type         = var.storage_account_type
  timezone_id                  = var.timezone_id
  collation                    = var.collation

  dynamic "identity" {
    for_each = var.identity_type != null ? [var.identity_type] : []
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}

# Optional Azure Active Directory / Microsoft Entra Administrator
resource "azurerm_mssql_managed_instance_active_directory_administrator" "this" {
  count                       = var.azuread_administrator != null ? 1 : 0
  managed_instance_id         = azurerm_mssql_managed_instance.this.id
  login_username              = var.azuread_administrator.login_username
  object_id                   = var.azuread_administrator.object_id
  tenant_id                   = lookup(var.azuread_administrator, "tenant_id", null)
  azuread_authentication_only = lookup(var.azuread_administrator, "azuread_authentication_only", false)
}

# Optional Managed Databases
resource "azurerm_mssql_managed_database" "databases" {
  for_each            = toset(var.database_names)
  name                = each.value
  managed_instance_id = azurerm_mssql_managed_instance.this.id
}
