# Azure Cosmos DB Terraform Module

This module deploys an Azure Cosmos DB Account supporting SQL (Core) API, multi-region replication, custom consistency levels, and container provisionings.

## Usage Example

```hcl
module "cosmos" {
  source              = "../../modules/cosmos_db"
  account_name        = "cosmos-app-prod-001"
  location            = "eastus"
  resource_group_name = "rg-data-prod"
  consistency_level   = "Session"
  sql_database_name   = "appdb"
  environment         = "prod"

  geo_locations = [
    {
      location          = "eastus"
      failover_priority = 0
      zone_redundant    = true
    },
    {
      location          = "westus"
      failover_priority = 1
      zone_redundant    = false
    }
  ]

  sql_containers = {
    "users" = {
      partition_key_path = "/userId"
      throughput         = 400
    },
    "orders" = {
      partition_key_path = "/orderId"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `account_name` | Cosmos DB Account name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `geo_locations` | List of locations & failover priority | `list(object)` | n/a | yes |
| `consistency_level` | Session, Strong, Eventual, etc. | `string` | `"Session"` | no |
| `sql_database_name` | Optional SQL Database name | `string` | `null` | no |
| `sql_containers` | Map of SQL containers | `map` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `cosmos_account_id` | Resource ID of Cosmos Account |
| `cosmos_account_name` | Name of Cosmos Account |
| `cosmos_endpoint` | Primary endpoint URL |
| `primary_key` | Master key (sensitive) |
| `primary_sql_connection_string` | Connection string (sensitive) |
