# Azure Log Analytics Workspace Terraform Module

This module provisions an Azure Log Analytics Workspace with custom data retention policies, ingestion quotas, and solutions (e.g. Container Insights).

## Usage Example

```hcl
module "log_analytics" {
  source              = "../../modules/log_analytics_workspace"
  workspace_name      = "law-ops-prod-001"
  location            = "eastus"
  resource_group_name = "rg-logging-prod"
  sku                 = "PerGB2018"
  retention_in_days   = 90
  environment         = "prod"

  solutions = {
    "ContainerInsights" = {
      publisher = "Microsoft"
      product   = "OMSGallery/ContainerInsights"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `workspace_name` | Workspace name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `sku` | PerGB2018, Standalone, etc. | `string` | `"PerGB2018"` | no |
| `retention_in_days` | Data retention (30-730 days) | `number` | `30` | no |
| `daily_quota_gb` | Daily quota in GB (-1 for unlimited) | `number` | `-1` | no |
| `solutions` | Map of solutions to enable | `map` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `workspace_id` | Resource ID of Workspace |
| `workspace_name` | Name of Workspace |
| `workspace_key` | Primary Shared Key (sensitive) |
