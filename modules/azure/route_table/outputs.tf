output "route_table_id" {
  description = "The ID of the Route Table."
  value       = azurerm_route_table.this.id
}

output "route_table_name" {
  description = "The name of the Route Table."
  value       = azurerm_route_table.this.name
}

output "route_table_subnets" {
  description = "The collection of Subnets associated with this route table."
  value       = azurerm_route_table.this.subnets
}
