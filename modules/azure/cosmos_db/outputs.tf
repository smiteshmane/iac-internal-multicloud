output "cosmos_account_id" {
  description = "The ID of the Cosmos DB Account."
  value       = azurerm_cosmosdb_account.this.id
}

output "cosmos_account_name" {
  description = "The name of the Cosmos DB Account."
  value       = azurerm_cosmosdb_account.this.name
}

output "cosmos_endpoint" {
  description = "The primary endpoint URL for the Cosmos DB Account."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "primary_key" {
  description = "The primary master key for the Cosmos DB Account (sensitive)."
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "primary_sql_connection_string" {
  description = "The primary SQL connection string (sensitive)."
  value       = azurerm_cosmosdb_account.this.primary_sql_connection_string
  sensitive   = true
}
