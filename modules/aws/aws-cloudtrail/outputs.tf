output "trail_arn" {
  description = "The ARN of the trail"
  value       = try(aws_cloudtrail.this[0].arn, "")
}

output "trail_id" {
  description = "The name of the trail"
  value       = try(aws_cloudtrail.this[0].id, "")
}

output "trail_home_region" {
  description = "The region in which the trail was created"
  value       = try(aws_cloudtrail.this[0].home_region, "")
}

output "s3_bucket_id" {
  description = "The S3 bucket name storing the trail logs"
  value       = try(var.s3_bucket_name != null ? var.s3_bucket_name : aws_s3_bucket.this[0].id, "")
}

output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group"
  value       = try(aws_cloudwatch_log_group.this[0].arn, "")
}
