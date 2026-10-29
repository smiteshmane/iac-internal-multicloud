output "table_name" {
  description = "Name of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].name, "")
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].arn, "")
}

output "table_id" {
  description = "ID of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].id, "")
}
