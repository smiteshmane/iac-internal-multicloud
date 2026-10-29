# Azure Monitor Alert Terraform Module

This module provisions an Azure Monitor Action Group (Email and Webhook receivers) and sets up Metric Alert rules against Azure resources.

## Usage Example

```hcl
module "alerts" {
  source              = "../../modules/monitor_alert"
  action_group_name   = "ag-ops-alerts-prod"
  short_name          = "opsalerts"
  resource_group_name = "rg-monitor-prod"
  environment         = "prod"

  email_receivers = [
    {
      name          = "devops-team"
      email_address = "devops@example.com"
    }
  ]

  metric_alerts = {
    "HighCPUPercentage" = {
      scopes           = [module.linux_vm.vm_id]
      description      = "Alert when VM CPU percentage exceeds 85%"
      severity         = 1
      frequency        = "PT1M"
      window_size      = "PT5M"
      metric_namespace = "Microsoft.Compute/virtualMachines"
      metric_name      = "Percentage CPU"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 85
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `action_group_name` | Action Group name | `string` | n/a | yes |
| `short_name` | Action Group short name (<=12 chars) | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `email_receivers` | List of email receivers | `list` | `[]` | no |
| `webhook_receivers` | List of webhook receivers | `list` | `[]` | no |
| `metric_alerts` | Map of metric alert definitions | `map` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `action_group_id` | Resource ID of Action Group |
| `action_group_name` | Name of Action Group |
| `metric_alert_ids` | Map of Metric Alert rule IDs |
