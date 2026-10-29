output "lb_id" {
  description = "The ID and ARN of the load balancer"
  value       = try(aws_lb.this[0].id, "")
}

output "lb_arn" {
  description = "The ARN of the load balancer"
  value       = try(aws_lb.this[0].arn, "")
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.this[0].dns_name, "")
}

output "lb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in Route 53 Alias record)"
  value       = try(aws_lb.this[0].zone_id, "")
}

output "target_group_arns" {
  description = "Map of Target Group ARNs indexed by target group key"
  value       = { for k, v in aws_lb_target_group.this : k => v.arn }
}

output "target_group_names" {
  description = "Map of Target Group names indexed by target group key"
  value       = { for k, v in aws_lb_target_group.this : k => v.name }
}

output "https_listener_arns" {
  description = "List of ARNs of HTTPS listeners"
  value       = aws_lb_listener.https[*].arn
}

output "http_listener_arns" {
  description = "List of ARNs of HTTP listeners"
  value       = aws_lb_listener.http[*].arn
}
