output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = try(aws_acm_certificate.this[0].arn, "")
}

output "certificate_id" {
  description = "The ID of the certificate"
  value       = try(aws_acm_certificate.this[0].id, "")
}

output "domain_validation_options" {
  description = "Set of domain validation objects which can be used to complete certificate validation"
  value       = try(aws_acm_certificate.this[0].domain_validation_options, [])
}
