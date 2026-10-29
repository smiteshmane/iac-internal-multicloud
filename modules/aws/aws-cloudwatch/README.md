# AWS CloudWatch Terraform Module

Enterprise-grade Terraform module for managing AWS CloudWatch Log Groups, Metric Alarms, Composite Alarms, Dashboards, and integrated SNS topic notifications.

## Features

- **Encrypted Log Groups**: Configurable log retention periods and mandatory KMS key encryption option.
- **Metric Alarms**: Declarative metric alarm definition supporting thresholds, statistics, dimensions, and evaluation periods.
- **Composite Alarms**: Create complex alarm logic binding multiple metric states.
- **SNS Alarm Dispatch**: Automatic SNS topic creation and email/Slack webhook subscriptions for real-time alerting.
- **Dashboards**: Provision customized CloudWatch metrics dashboards via JSON structure.

## Usage Example

```hcl
module "cloudwatch" {
  source = "../../modules/aws-cloudwatch"

  project     = "acme"
  environment = "prod"
  name        = "app-monitoring"

  retention_in_days = 90

  sns_subscriptions = {
    ops_team = {
      protocol = "email"
      endpoint = "devops-alerts@example.com"
    }
  }

  metric_alarms = {
    high_cpu = {
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 300
      statistic           = "Average"
      threshold           = 85
      alarm_description   = "Triggers when EC2 instance CPU exceeds 85% for 10 minutes"
      dimensions = {
        InstanceId = "i-0123456789abcdef0"
      }
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether to create resources | `bool` | `true` | no |
| `project` | Project identifier | `string` | `"enterprise"` | no |
| `environment` | Environment identifier | `string` | n/a | yes |
| `name` | Resource name | `string` | `"monitoring"` | no |
| `retention_in_days` | Log retention period | `number` | `90` | no |
| `sns_subscriptions` | Map of SNS subscriptions | `map(object)` | `{}` | no |
| `metric_alarms` | Map of metric alarms | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `log_group_arn` | ARN of CloudWatch Log Group |
| `log_group_name` | Name of CloudWatch Log Group |
| `sns_topic_arn` | ARN of SNS Topic |
| `metric_alarm_arns` | Map of Metric Alarm ARNs |
