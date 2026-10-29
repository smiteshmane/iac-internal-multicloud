output "instance_id" {
  description = "The instance ID of the MemoryStore Redis cluster."
  value       = google_redis_instance.redis.name
}

output "host" {
  description = "The private IP host address of the Redis instance."
  value       = google_redis_instance.redis.host
}

output "port" {
  description = "The port number on which the Redis instance is listening."
  value       = google_redis_instance.redis.port
}

output "auth_string" {
  description = "The AUTH string for authenticating with the Redis instance."
  value       = google_redis_instance.redis.auth_string
  sensitive   = true
}
