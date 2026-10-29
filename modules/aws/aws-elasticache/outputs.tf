output "replication_group_id" {
  description = "ID of the Redis replication group"
  value       = try(aws_elasticache_replication_group.this[0].id, "")
}

output "primary_endpoint_address" {
  description = "Primary endpoint address of the Redis cluster"
  value       = try(aws_elasticache_replication_group.this[0].primary_endpoint_address, "")
}

output "reader_endpoint_address" {
  description = "Reader endpoint address of the Redis cluster"
  value       = try(aws_elasticache_replication_group.this[0].reader_endpoint_address, "")
}

output "port" {
  description = "Port number on which the cluster accepts connections"
  value       = try(aws_elasticache_replication_group.this[0].port, 6379)
}
