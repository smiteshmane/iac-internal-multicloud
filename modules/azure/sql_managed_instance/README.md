# Azure SQL Managed Instance Module

This module provisions an Azure SQL Managed Instance (General Purpose / Business Critical) with dedicated delegated subnet attachment, TLS 1.2 minimum, System-Assigned Identity, optional Microsoft Entra (Azure AD) administrator integration, and optional managed databases.

## Usage

```hcl
module "sql_managed_instance" {
  source                       = "../../modules/azure/sql_managed_instance"
  managed_instance_name        = "sqlinst-dev-eus2-001"
  resource_group_name          = "rg-Data-Migration-POC"
  location                     = "eastus2"
  subnet_id                    = module.subnet_mi.subnet_id
  sku_name                     = "GP_Gen5"
  vcores                       = 4
  storage_size_in_gb           = 32
  license_type                 = "LicenseIncluded"
  administrator_login          = "sqladmin"
  administrator_login_password = var.administrator_login_password
  storage_account_type         = "LRS"

  tags = {
    Environment = "dev"
    Project     = "Data-Migration-POC"
  }
}
```
