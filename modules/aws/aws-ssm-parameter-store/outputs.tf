output "parameter_name" {
  description = "Name of the SSM Parameter"
  value       = try(aws_ssm_parameter.this[0].name, "")
}

output "parameter_arn" {
  description = "ARN of the SSM Parameter"
  value       = try(aws_ssm_parameter.this[0].arn, "")
}

output "parameter_version" {
  description = "Version of the SSM Parameter"
  value       = try(aws_ssm_parameter.this[0].version, 1)
}
