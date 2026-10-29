output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "vnet_address_space" {
  description = "The list of address spaces of the Virtual Network."
  value       = azurerm_virtual_network.this.address_space
}

output "vnet_subnets" {
  description = "The subnets created within the Virtual Network."
  value       = azurerm_virtual_network.this.subnet
}
