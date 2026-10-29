# Azure Virtual Network Terraform Module

This module deploys an Azure Virtual Network (VNet) supporting custom address spaces, DNS server configurations, DDoS protection plans, and standard resource tagging.

## Usage Example

```hcl
module "vnet" {
  source              = "../../modules/virtual_network"
  vnet_name           = "vnet-prod-eastus-001"
  location            = "eastus"
  resource_group_name = "rg-network-prod"
  address_space       = ["10.0.0.0/16"]
  environment         = "prod"

  tags = {
    Project    = "Core Infrastructure"
    CostCenter = "IT-101"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vnet_name` | Name of the Virtual Network | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `address_space` | List of IP address blocks | `list(string)` | `["10.0.0.0/16"]` | no |
| `dns_servers` | List of DNS server IPs | `list(string)` | `[]` | no |
| `ddos_protection_plan_id` | ID of DDoS Protection Plan | `string` | `null` | no |
| `environment` | Environment name (dev, test, prod) | `string` | `"dev"` | no |
| `tags` | Map of tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vnet_id` | Resource ID of the Virtual Network |
| `vnet_name` | Name of the Virtual Network |
| `vnet_address_space` | Configured address spaces |
| `vnet_subnets` | Inline subnets (if defined) |
