output "function_name" {
  description = "The name of the Lambda function"
  value       = try(aws_lambda_function.this[0].function_name, "")
}

output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = try(aws_lambda_function.this[0].arn, "")
}

output "invoke_arn" {
  description = "The Invoke ARN of the Lambda function (for API Gateway integration)"
  value       = try(aws_lambda_function.this[0].invoke_arn, "")
}

output "role_arn" {
  description = "The IAM Role ARN of the Lambda function"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "role_name" {
  description = "The IAM Role name of the Lambda function"
  value       = try(aws_iam_role.this[0].name, "")
}
