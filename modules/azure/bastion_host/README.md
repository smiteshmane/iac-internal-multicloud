# Azure Bastion Host Terraform Module

This module provisions an Azure Bastion Host placed inside a dedicated `AzureBastionSubnet` with options for Standard SKU, native client tunneling, file copy, and scale units.

## Usage Example

```hcl
module "bastion" {
  source                  = "../../modules/bastion_host"
  bastion_host_name       = "bas-ops-prod-001"
  location                = "eastus"
  resource_group_name     = "rg-bastion-prod"
  azure_bastion_subnet_id = module.bastion_subnet.subnet_id
  public_ip_id            = module.bastion_pip.public_ip_id
  sku                     = "Standard"
  scale_units             = 2
  tunneling_enabled       = true
  environment             = "prod"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `bastion_host_name` | Bastion Host name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `azure_bastion_subnet_id` | Subnet ID (`AzureBastionSubnet`) | `string` | n/a | yes |
| `public_ip_id` | Public IP ID | `string` | n/a | yes |
| `sku` | Basic or Standard | `string` | `"Standard"` | no |
| `scale_units` | Number of scale units (2-50) | `number` | `2` | no |
| `tunneling_enabled` | Enable native SSH/RDP tunneling | `bool` | `true` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `bastion_host_id` | Resource ID of Bastion Host |
| `bastion_host_name` | Name of Bastion Host |
| `dns_name` | FQDN DNS name |
