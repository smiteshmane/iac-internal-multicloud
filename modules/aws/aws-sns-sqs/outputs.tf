output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = try(aws_sns_topic.this[0].arn, "")
}

output "sns_topic_name" {
  description = "Name of the SNS topic"
  value       = try(aws_sns_topic.this[0].name, "")
}

output "sqs_queue_arn" {
  description = "ARN of the primary SQS queue"
  value       = try(aws_sqs_queue.this[0].arn, "")
}

output "sqs_queue_url" {
  description = "URL of the primary SQS queue"
  value       = try(aws_sqs_queue.this[0].id, "")
}

output "dlq_queue_arn" {
  description = "ARN of the Dead Letter Queue (DLQ)"
  value       = try(aws_sqs_queue.dlq[0].arn, "")
}
