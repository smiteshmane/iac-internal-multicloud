output "iam_role_arn" {
  description = "ARN of the created IAM role"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "iam_role_name" {
  description = "Name of the created IAM role"
  value       = try(aws_iam_role.this[0].name, "")
}

output "iam_role_id" {
  description = "ID of the created IAM role"
  value       = try(aws_iam_role.this[0].id, "")
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the role"
  value       = try(aws_iam_role.this[0].unique_id, "")
}

output "instance_profile_arn" {
  description = "ARN of the created instance profile (if create_instance_profile is true)"
  value       = try(aws_iam_instance_profile.this[0].arn, "")
}

output "instance_profile_name" {
  description = "Name of the created instance profile (if create_instance_profile is true)"
  value       = try(aws_iam_instance_profile.this[0].name, "")
}
