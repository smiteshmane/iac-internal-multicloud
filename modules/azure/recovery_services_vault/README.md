# Azure Recovery Services Vault Terraform Module

This module provisions an Azure Recovery Services Vault with soft-delete, storage redundancy, and customizable VM backup policies.

## Usage Example

```hcl
module "rsv" {
  source              = "../../modules/recovery_services_vault"
  vault_name          = "rsv-backup-prod-001"
  location            = "eastus"
  resource_group_name = "rg-backup-prod"
  sku                 = "Standard"
  storage_mode_type   = "GeoRedundant"
  soft_delete_enabled = true
  environment         = "prod"

  backup_policies = {
    "daily-vm-backup" = {
      backup_frequency      = "Daily"
      backup_time           = "23:00"
      retention_daily_count = 14
      timezone              = "UTC"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vault_name` | Vault name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `sku` | Standard or RS0 | `string` | `"Standard"` | no |
| `storage_mode_type` | GeoRedundant, LocallyRedundant, ZoneRedundant | `string` | `"GeoRedundant"` | no |
| `soft_delete_enabled` | Enable soft-delete | `bool` | `true` | no |
| `backup_policies` | Map of VM backup policies | `map` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vault_id` | Resource ID of Recovery Services Vault |
| `vault_name` | Name of Vault |
| `backup_policy_ids` | Map of backup policy IDs |
