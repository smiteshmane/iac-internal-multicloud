output "app_gateway_id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.this.id
}

output "app_gateway_name" {
  description = "The name of the Application Gateway."
  value       = azurerm_application_gateway.this.name
}

output "backend_address_pool_id" {
  description = "The ID of the Backend Address Pool."
  value       = azurerm_application_gateway.this.backend_address_pool[0].id
}
