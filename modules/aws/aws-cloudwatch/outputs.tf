output "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group"
  value       = try(aws_cloudwatch_log_group.this[0].arn, "")
}

output "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = try(aws_cloudwatch_log_group.this[0].name, "")
}

output "sns_topic_arn" {
  description = "The ARN of the SNS Topic created for alarms"
  value       = try(aws_sns_topic.alarms[0].arn, "")
}

output "metric_alarm_arns" {
  description = "Map of Metric Alarm ARNs indexed by key"
  value       = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.arn }
}

output "composite_alarm_arns" {
  description = "Map of Composite Alarm ARNs indexed by key"
  value       = { for k, v in aws_cloudwatch_composite_alarm.this : k => v.arn }
}

output "dashboard_arn" {
  description = "The ARN of the CloudWatch Dashboard"
  value       = try(aws_cloudwatch_dashboard.this[0].dashboard_arn, "")
}
