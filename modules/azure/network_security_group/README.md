# Network Security Group (NSG) Terraform Module

This module provisions an Azure Network Security Group (NSG), configures custom inbound and outbound security rules, and optionally associates the NSG with a target Subnet.

## Usage Example

```hcl
module "app_nsg" {
  source              = "../../modules/network_security_group"
  nsg_name            = "nsg-app-prod-001"
  location            = "eastus"
  resource_group_name = "rg-network-prod"
  subnet_id           = module.app_subnet.subnet_id
  environment         = "prod"

  security_rules = [
    {
      name                       = "AllowHTTPSInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowSSHFromAdmin"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "22"
      source_address_prefix      = "10.100.0.0/16"
      destination_address_prefix = "*"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `nsg_name` | Name of the NSG | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `subnet_id` | Optional Subnet ID for association | `string` | `null` | no |
| `security_rules` | Custom security rules | `list(object)` | `[]` | no |
| `environment` | Environment name | `string` | `"dev"` | no |
| `tags` | Map of tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `nsg_id` | Resource ID of the NSG |
| `nsg_name` | Name of the NSG |
