output "distribution_id" {
  description = "The identifier for the distribution"
  value       = try(aws_cloudfront_distribution.this[0].id, "")
}

output "distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution"
  value       = try(aws_cloudfront_distribution.this[0].arn, "")
}

output "domain_name" {
  description = "The domain name corresponding to the distribution"
  value       = try(aws_cloudfront_distribution.this[0].domain_name, "")
}

output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias resource record set"
  value       = try(aws_cloudfront_distribution.this[0].hosted_zone_id, "")
}
