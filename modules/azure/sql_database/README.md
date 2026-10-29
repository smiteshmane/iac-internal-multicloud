# Azure SQL Database Terraform Module

This module provisions an Azure SQL Server and Database with enforced TLS 1.2 minimum, Azure Active Directory admin support, firewall rules, and Key Vault integration for secrets.

## Usage Example

```hcl
module "sql_db" {
  source                       = "../../modules/sql_database"
  sql_server_name              = "sql-app-prod-001"
  database_name                = "sqldb-app-prod"
  location                     = "eastus"
  resource_group_name          = "rg-db-prod"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
  sku_name                     = "GP_Gen5_2"
  max_size_gb                  = 50
  environment                  = "prod"

  firewall_rules = {
    "AllowAzureServices" = {
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sql_server_name` | SQL Server name (globally unique) | `string` | n/a | yes |
| `database_name` | SQL Database name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `administrator_login_password` | Admin password (sensitive) | `string` | n/a | yes |
| `administrator_login` | Admin login | `string` | `"sqladmin"` | no |
| `sku_name` | Database SKU | `string` | `"S0"` | no |
| `max_size_gb` | Max size in GB | `number` | `10` | no |
| `firewall_rules` | Map of firewall rules | `map` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `sql_server_id` | Resource ID of SQL Server |
| `sql_server_fully_qualified_domain_name` | FQDN of SQL Server |
| `database_id` | Resource ID of SQL Database |
| `database_name` | Name of SQL Database |
