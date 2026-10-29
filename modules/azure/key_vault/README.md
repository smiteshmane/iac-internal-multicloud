# Azure Key Vault Terraform Module

This module deploys an Azure Key Vault configured with RBAC authorization, soft-delete, purge protection, network ACLs, and initial secrets seeding.

## Usage Example

```hcl
module "key_vault" {
  source                    = "../../modules/key_vault"
  key_vault_name            = "kv-core-prod-001"
  location                  = "eastus"
  resource_group_name       = "rg-sec-prod"
  sku_name                  = "standard"
  enable_rbac_authorization = true
  purge_protection_enabled  = true
  environment               = "prod"

  secrets = {
    "db-password"    = var.db_password
    "api-secret-key" = var.api_secret_key
  }

  network_acls = {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = ["198.51.100.10/32"]
    virtual_network_subnet_ids = [module.app_subnet.subnet_id]
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `key_vault_name` | Globally unique Key Vault name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `sku_name` | standard or premium | `string` | `"standard"` | no |
| `soft_delete_retention_days` | Soft delete days | `number` | `90` | no |
| `purge_protection_enabled` | Enable purge protection | `bool` | `true` | no |
| `enable_rbac_authorization` | Enable Azure RBAC | `bool` | `true` | no |
| `network_acls` | Firewall configuration | `object` | `null` | no |
| `secrets` | Map of secrets (sensitive) | `map(string)` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `key_vault_id` | Resource ID of Key Vault |
| `key_vault_name` | Name of Key Vault |
| `key_vault_uri` | Vault URI endpoint |
| `secrets` | Map of created secret IDs |
