output "security_group_id" {
  description = "The ID of the security group"
  value       = try(aws_security_group.this[0].id, "")
}

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = try(aws_security_group.this[0].arn, "")
}

output "security_group_vpc_id" {
  description = "The VPC ID of the security group"
  value       = try(aws_security_group.this[0].vpc_id, "")
}

output "security_group_name" {
  description = "The name of the security group"
  value       = try(aws_security_group.this[0].name, "")
}

output "security_group_description" {
  description = "The description of the security group"
  value       = try(aws_security_group.this[0].description, "")
}

output "ingress_rule_ids" {
  description = "List of IDs of created ingress rules"
  value       = aws_vpc_security_group_ingress_rule.this[*].id
}

output "egress_rule_ids" {
  description = "List of IDs of created egress rules"
  value       = aws_vpc_security_group_egress_rule.this[*].id
}
