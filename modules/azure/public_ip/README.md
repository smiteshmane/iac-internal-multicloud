# Azure Public IP Terraform Module

This module provisions an Azure Public IP address supporting Standard SKU, zone-redundancy, and custom DNS domain name labels.

## Usage Example

```hcl
module "pip" {
  source              = "../../modules/public_ip"
  public_ip_name      = "pip-app-prod-001"
  location            = "eastus"
  resource_group_name = "rg-network-prod"
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "myapp-prod-api"
  environment         = "prod"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `public_ip_name` | Name of the Public IP | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `allocation_method` | Static or Dynamic | `string` | `"Static"` | no |
| `sku` | Basic or Standard | `string` | `"Standard"` | no |
| `sku_tier` | Regional or Global | `string` | `"Regional"` | no |
| `domain_name_label` | Optional DNS name prefix | `string` | `null` | no |
| `idle_timeout_in_minutes` | TCP idle timeout | `number` | `4` | no |
| `zones` | Availability zones | `list(string)` | `["1", "2", "3"]` | no |
| `environment` | Environment name | `string` | `"dev"` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `public_ip_id` | Resource ID of the Public IP |
| `public_ip_address` | The assigned Public IP address |
| `fqdn` | Fully Qualified Domain Name |
