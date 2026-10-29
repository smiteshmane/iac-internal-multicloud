# Azure Virtual Machine Scale Set (VMSS) Terraform Module

This module provisions an Azure Linux VM Scale Set integrated with a Load Balancer backend pool and Managed Identity.

## Usage Example

```hcl
module "vmss" {
  source                                 = "../../modules/virtual_machine_scale_set"
  vmss_name                              = "vmss-web-prod-001"
  location                               = "eastus"
  resource_group_name                    = "rg-compute-prod"
  subnet_id                              = module.app_subnet.subnet_id
  load_balancer_backend_address_pool_ids = [module.lb.backend_address_pool_id]
  sku                                    = "Standard_D2s_v5"
  instances                              = 3
  admin_username                         = "azureadmin"
  ssh_public_key                         = file("~/.ssh/id_rsa.pub")
  environment                            = "prod"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vmss_name` | Name of the Scale Set | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `subnet_id` | Subnet ID | `string` | n/a | yes |
| `sku` | VM SKU size | `string` | `"Standard_D2s_v5"` | no |
| `instances` | Instance count | `number` | `2` | no |
| `load_balancer_backend_address_pool_ids` | LB backend pool IDs | `list(string)` | `[]` | no |
| `admin_username` | Admin username | `string` | `"azureuser"` | no |
| `ssh_public_key` | SSH Public Key | `string` | `null` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vmss_id` | Resource ID of the VM Scale Set |
| `vmss_name` | Name of the Scale Set |
| `principal_id` | Managed Identity Principal ID |
