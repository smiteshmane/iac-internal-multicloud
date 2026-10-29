output "repository_arn" {
  description = "Full ARN of the ECR repository"
  value       = try(aws_ecr_repository.this[0].arn, "")
}

output "repository_name" {
  description = "The name of the ECR repository"
  value       = try(aws_ecr_repository.this[0].name, "")
}

output "repository_url" {
  description = "The URL of the repository (format: AWS_ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/REPOSITORY_NAME)"
  value       = try(aws_ecr_repository.this[0].repository_url, "")
}

output "registry_id" {
  description = "The registry ID where the repository was created"
  value       = try(aws_ecr_repository.this[0].registry_id, "")
}
