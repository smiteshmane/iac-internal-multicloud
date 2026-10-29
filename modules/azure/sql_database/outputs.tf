output "sql_server_id" {
  description = "The ID of the SQL Server."
  value       = azurerm_mssql_server.this.id
}

output "sql_server_fully_qualified_domain_name" {
  description = "The fully qualified domain name (FQDN) of the SQL Server."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "The ID of the SQL Database."
  value       = azurerm_mssql_database.this.id
}

output "database_name" {
  description = "The name of the SQL Database."
  value       = azurerm_mssql_database.this.name
}
