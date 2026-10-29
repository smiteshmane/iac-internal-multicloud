# Azure App Service Terraform Module

This module provisions an Azure App Service Plan (Linux/Windows) and Web App with HTTPS enforcement, FTPS disabled, TLS 1.2 minimum, Managed Identity, and optional VNet Integration.

## Usage Example

```hcl
module "web_app" {
  source                      = "../../modules/app_service"
  app_service_plan_name       = "asp-core-prod-001"
  app_service_name            = "app-frontend-prod-001"
  location                    = "eastus"
  resource_group_name         = "rg-app-prod"
  os_type                     = "Linux"
  sku_name                    = "P1v3"
  vnet_integration_subnet_id  = module.app_subnet.subnet_id
  environment                 = "prod"

  application_stack = {
    node_version = "18-lts"
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "ENVIRONMENT"                  = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `app_service_plan_name` | Plan name | `string` | n/a | yes |
| `app_service_name` | Web app name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `os_type` | Linux or Windows | `string` | `"Linux"` | no |
| `sku_name` | Plan SKU (B1, P1v3, etc.) | `string` | `"P1v3"` | no |
| `vnet_integration_subnet_id` | Subnet ID for VNet Integration | `string` | `null` | no |
| `application_stack` | Application runtime block | `object` | `null` | no |
| `app_settings` | App settings key-value map | `map(string)` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `app_service_plan_id` | Resource ID of App Service Plan |
| `web_app_id` | Resource ID of Web App |
| `default_hostname` | Default FQDN hostname |
| `principal_id` | Managed Identity Principal ID |
