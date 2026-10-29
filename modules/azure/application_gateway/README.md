# Azure Application Gateway Terraform Module

This module provisions an Azure Application Gateway v2 (Standard_v2 or WAF_v2) with HTTP/HTTPS listeners, routing rules, backend address pool, and autoscale options.

## Usage Example

```hcl
module "app_gateway" {
  source               = "../../modules/application_gateway"
  app_gateway_name     = "agw-core-prod-001"
  location             = "eastus"
  resource_group_name  = "rg-network-prod"
  subnet_id            = module.agw_subnet.subnet_id
  public_ip_id         = module.pip.public_ip_id
  sku_name             = "Standard_v2"
  sku_tier             = "Standard_v2"
  environment          = "prod"

  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 10
  }

  backend_ip_addresses = ["10.0.1.10", "10.0.1.11"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `app_gateway_name` | App Gateway name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `subnet_id` | Dedicated subnet ID | `string` | n/a | yes |
| `public_ip_id` | Public IP ID | `string` | n/a | yes |
| `sku_name` | Standard_v2 or WAF_v2 | `string` | `"Standard_v2"` | no |
| `autoscale_configuration` | Min and Max capacity | `object` | `null` | no |
| `backend_ip_addresses` | Target backend IP list | `list(string)` | `[]` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `app_gateway_id` | Resource ID of App Gateway |
| `app_gateway_name` | Name of App Gateway |
| `backend_address_pool_id` | Backend Pool ID |
