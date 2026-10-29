# Azure Virtual Machine Terraform Module

This module provisions a Linux or Windows Virtual Machine with Network Interface, OS Disk settings, Managed Identity support, and SSH key or Key Vault password integration.

## Usage Example

```hcl
module "linux_vm" {
  source              = "../../modules/virtual_machine"
  vm_name             = "vm-app-prod-001"
  location            = "eastus"
  resource_group_name = "rg-compute-prod"
  subnet_id           = module.app_subnet.subnet_id
  vm_size             = "Standard_D2s_v5"
  os_type             = "Linux"
  admin_username      = "azureadmin"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  environment         = "prod"

  tags = {
    Role = "AppServer"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vm_name` | Name of the VM | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `subnet_id` | Subnet ID for NIC | `string` | n/a | yes |
| `os_type` | OS Type (`Linux` or `Windows`) | `string` | `"Linux"` | no |
| `vm_size` | VM SKU | `string` | `"Standard_D2s_v5"` | no |
| `admin_username` | Admin username | `string` | `"azureuser"` | no |
| `admin_password` | Admin password (sensitive) | `string` | `null` | no |
| `disable_password_authentication` | Enforce SSH key for Linux | `bool` | `true` | no |
| `ssh_public_key` | SSH Public Key content | `string` | `null` | no |
| `identity_type` | Identity type | `string` | `"SystemAssigned"` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vm_id` | Resource ID of the VM |
| `nic_id` | Resource ID of Network Interface |
| `private_ip_address` | Private IP address |
| `principal_id` | Managed Identity Principal ID |
