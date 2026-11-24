output "managed_instance_id" {
  description = "The ID of the SQL Managed Instance."
  value       = azurerm_mssql_managed_instance.this.id
}

output "managed_instance_name" {
  description = "The name of the SQL Managed Instance."
  value       = azurerm_mssql_managed_instance.this.name
}

output "fqdn" {
  description = "The fully qualified domain name of the Azure Managed Instance."
  value       = azurerm_mssql_managed_instance.this.fqdn
}

output "principal_id" {
  description = "The Principal ID for the Service Principal associated with the Identity of this SQL Managed Instance."
  value       = try(azurerm_mssql_managed_instance.this.identity[0].principal_id, null)
}

output "database_ids" {
  description = "Map of managed database names to IDs."
  value       = { for k, db in azurerm_mssql_managed_database.databases : k => db.id }
}
