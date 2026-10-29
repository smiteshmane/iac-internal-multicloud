output "secret_arn" {
  description = "ARN of the secret"
  value       = try(aws_secretsmanager_secret.this[0].arn, "")
}

output "secret_id" {
  description = "ID of the secret"
  value       = try(aws_secretsmanager_secret.this[0].id, "")
}

output "secret_name" {
  description = "Name of the secret"
  value       = try(aws_secretsmanager_secret.this[0].name, "")
}

output "secret_version_id" {
  description = "The unique identifier of the version of the secret"
  value       = try(aws_secretsmanager_secret_version.this[0].version_id, "")
}
