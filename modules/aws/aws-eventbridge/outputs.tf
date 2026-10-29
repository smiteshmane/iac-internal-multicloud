output "event_bus_name" {
  description = "Name of the EventBridge EventBus"
  value       = try(aws_cloudwatch_event_bus.this[0].name, "default")
}

output "event_bus_arn" {
  description = "ARN of the EventBridge EventBus"
  value       = try(aws_cloudwatch_event_bus.this[0].arn, "")
}

output "rule_arn" {
  description = "ARN of the EventBridge Event Rule"
  value       = try(aws_cloudwatch_event_rule.this[0].arn, "")
}

output "rule_name" {
  description = "Name of the EventBridge Event Rule"
  value       = try(aws_cloudwatch_event_rule.this[0].name, "")
}
