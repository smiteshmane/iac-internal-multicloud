output "db_instance_address" {
  description = "The hostname of the RDS instance"
  value       = try(aws_db_instance.this[0].address, "")
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.this[0].arn, "")
}

output "db_instance_endpoint" {
  description = "The connection endpoint in address:port format"
  value       = try(aws_db_instance.this[0].endpoint, "")
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = try(aws_db_instance.this[0].identifier, "")
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = try(aws_db_instance.this[0].id, "")
}

output "db_instance_name" {
  description = "The database name"
  value       = try(aws_db_instance.this[0].db_name, "")
}

output "db_instance_port" {
  description = "The database port"
  value       = try(aws_db_instance.this[0].port, "")
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = try(aws_db_instance.this[0].username, "")
  sensitive   = true
}

output "master_password" {
  description = "The master password for the database"
  value       = try(random_password.master_password[0].result, var.password)
  sensitive   = true
}

output "db_subnet_group_id" {
  description = "The DB subnet group ID"
  value       = try(aws_db_subnet_group.this[0].id, "")
}

output "db_parameter_group_id" {
  description = "The DB parameter group ID"
  value       = try(aws_db_parameter_group.this[0].id, "")
}
