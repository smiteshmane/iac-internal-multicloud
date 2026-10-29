output "cluster_id" {
  description = "The ID of the ECS cluster"
  value       = try(aws_ecs_cluster.this[0].id, "")
}

output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = try(aws_ecs_cluster.this[0].arn, "")
}

output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = try(aws_ecs_cluster.this[0].name, "")
}

output "service_id" {
  description = "The ID of the ECS service"
  value       = try(aws_ecs_service.this[0].id, "")
}

output "service_name" {
  description = "The name of the ECS service"
  value       = try(aws_ecs_service.this[0].name, "")
}

output "task_definition_arn" {
  description = "Full ARN of the ECS task definition"
  value       = try(aws_ecs_task_definition.this[0].arn, "")
}

output "log_group_name" {
  description = "Name of the CloudWatch log group created for ECS task logs"
  value       = try(aws_cloudwatch_log_group.this[0].name, "")
}
