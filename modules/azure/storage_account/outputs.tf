output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_access_key" {
  description = "The primary access key for the storage account (sensitive)."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string for the storage account (sensitive)."
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "containers" {
  description = "Map of created containers and their IDs."
  value       = { for k, v in azurerm_storage_container.containers : k => v.id }
}
