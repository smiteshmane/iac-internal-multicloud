output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = try(aws_kms_key.this[0].arn, "")
}

output "key_id" {
  description = "The globally unique identifier for the key"
  value       = try(aws_kms_key.this[0].key_id, "")
}

output "alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias"
  value       = try(aws_kms_alias.this[0].arn, "")
}

output "alias_name" {
  description = "The display name of the alias"
  value       = try(aws_kms_alias.this[0].name, "")
}
