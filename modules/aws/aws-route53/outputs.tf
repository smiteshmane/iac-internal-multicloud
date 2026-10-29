output "zone_id" {
  description = "The Hosted Zone ID"
  value       = try(aws_route53_zone.this[0].zone_id, "")
}

output "zone_arn" {
  description = "The Hosted Zone ARN"
  value       = try(aws_route53_zone.this[0].arn, "")
}

output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set"
  value       = try(aws_route53_zone.this[0].name_servers, [])
}

output "record_fqdns" {
  description = "List of FQDNs of created records"
  value       = aws_route53_record.this[*].fqdn
}
