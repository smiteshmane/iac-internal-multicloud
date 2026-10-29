output "web_acl_id" {
  description = "The ID of the WAFv2 Web ACL"
  value       = try(aws_wafv2_web_acl.this[0].id, "")
}

output "web_acl_arn" {
  description = "The ARN of the WAFv2 Web ACL"
  value       = try(aws_wafv2_web_acl.this[0].arn, "")
}

output "web_acl_capacity" {
  description = "The capacity units (WCU) consumed by the WAFv2 Web ACL"
  value       = try(aws_wafv2_web_acl.this[0].capacity, 0)
}

output "association_ids" {
  description = "List of IDs for resource associations"
  value       = aws_wafv2_web_acl_association.this[*].id
}
