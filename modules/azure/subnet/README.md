# Azure Subnet Terraform Module

This module creates a Subnet inside an Azure Virtual Network supporting service endpoints, subnet delegation, and private endpoint network policies.

## Usage Example

```hcl
module "app_subnet" {
  source               = "../../modules/subnet"
  subnet_name          = "snet-app-prod-001"
  resource_group_name  = "rg-network-prod"
  virtual_network_name = "vnet-prod-eastus-001"
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]

  delegations = [
    {
      name         = "app-service-delegation"
      service_name = "Microsoft.Web/serverFarms"
      actions      = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `subnet_name` | Name of the Subnet | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `virtual_network_name` | Virtual Network name | `string` | n/a | yes |
| `address_prefixes` | List of IP prefixes | `list(string)` | n/a | yes |
| `service_endpoints` | List of Azure Service Endpoints | `list(string)` | `[]` | no |
| `private_endpoint_network_policies_enabled` | Enable PE network policies | `bool` | `true` | no |
| `private_link_service_network_policies_enabled` | Enable PLS network policies | `bool` | `true` | no |
| `delegations` | Subnet delegation rules | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `subnet_id` | Resource ID of the Subnet |
| `subnet_name` | Name of the Subnet |
| `address_prefixes` | Address prefixes assigned |
