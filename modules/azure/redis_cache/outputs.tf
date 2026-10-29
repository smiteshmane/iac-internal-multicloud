output "redis_id" {
  description = "The ID of the Redis Cache instance."
  value       = azurerm_redis_cache.this.id
}

output "redis_hostname" {
  description = "The Hostname of the Redis Cache instance."
  value       = azurerm_redis_cache.this.hostname
}

output "redis_ssl_port" {
  description = "The SSL Port of the Redis Cache instance."
  value       = azurerm_redis_cache.this.ssl_port
}

output "primary_access_key" {
  description = "The Primary Access Key for the Redis Cache instance (sensitive)."
  value       = azurerm_redis_cache.this.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The Primary Connection String for the Redis Cache instance (sensitive)."
  value       = azurerm_redis_cache.this.primary_connection_string
  sensitive   = true
}
