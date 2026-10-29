# Azure Storage Account Terraform Module

This module provisions an Azure Storage Account with enforced TLS 1.2+, HTTPS enforcement, blob retention policies, optional network rules, and container creation.

## Usage Example

```hcl
module "storage" {
  source                   = "../../modules/storage_account"
  storage_account_name     = "stappdata101prod"
  location                 = "eastus"
  resource_group_name      = "rg-storage-prod"
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  enable_blob_versioning   = true
  environment              = "prod"

  containers = {
    "documents" = { container_access_type = "private" }
    "backups"   = { container_access_type = "private" }
  }

  network_rules = {
    default_action             = "Deny"
    ip_rules                   = ["203.0.113.5"]
    virtual_network_subnet_ids = [module.app_subnet.subnet_id]
    bypass                     = ["AzureServices"]
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `storage_account_name` | Name (alphanumeric lowercase) | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `account_tier` | Standard or Premium | `string` | `"Standard"` | no |
| `account_replication_type` | LRS, GRS, ZRS, etc. | `string` | `"GRS"` | no |
| `public_network_access_enabled` | Enable public network access | `bool` | `true` | no |
| `enable_blob_versioning` | Enable blob versioning | `bool` | `true` | no |
| `containers` | Map of containers to create | `map` | `{}` | no |
| `network_rules` | Network firewall rules | `object` | `null` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `storage_account_id` | Resource ID of Storage Account |
| `storage_account_name` | Name of Storage Account |
| `primary_blob_endpoint` | Primary blob endpoint URL |
| `primary_access_key` | Primary access key (sensitive) |
| `primary_connection_string` | Connection string (sensitive) |
| `containers` | Map of container IDs |
