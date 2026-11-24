# Azure Route Table Module

This module provisions an Azure Route Table, configures custom routes, and optionally associates it with a Subnet.

## Usage

```hcl
module "route_table" {
  source              = "../../modules/azure/route_table"
  route_table_name    = "rt-mi-dev-eus2-001"
  resource_group_name = "rg-Data-Migration-POC"
  location            = "eastus2"
  subnet_id           = module.subnet_mi.subnet_id

  routes = [
    {
      name           = "default-route"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "Data-Migration-POC"
  }
}
```
