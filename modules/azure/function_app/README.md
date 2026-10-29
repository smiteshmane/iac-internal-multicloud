# Azure Function App Terraform Module

This module provisions an Azure Function App with dedicated Storage Account binding, Application Insights integration, HTTPS enforcement, and VNet integration.

## Usage Example

```hcl
module "func_app" {
  source                     = "../../modules/function_app"
  function_app_name          = "func-processor-prod-001"
  location                   = "eastus"
  resource_group_name        = "rg-func-prod"
  sku_name                   = "EP1"
  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.primary_access_key
  vnet_integration_subnet_id = module.app_subnet.subnet_id
  environment                = "prod"

  application_stack = {
    python_version = "3.10"
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `function_app_name` | Name of Function App | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `storage_account_name` | Storage account name | `string` | n/a | yes |
| `storage_account_access_key` | Storage key | `string` | n/a | yes |
| `sku_name` | Y1, EP1, P1v3, etc. | `string` | `"Y1"` | no |
| `application_insights_key` | App Insights key | `string` | `null` | no |
| `vnet_integration_subnet_id` | Subnet ID | `string` | `null` | no |
| `application_stack` | Runtime stack config | `object` | `null` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `function_app_id` | Resource ID of Function App |
| `function_app_name` | Name of Function App |
| `default_hostname` | Default hostname URL |
| `principal_id` | Managed Identity Principal ID |
