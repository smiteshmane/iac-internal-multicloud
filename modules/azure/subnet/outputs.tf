output "subnet_id" {
  description = "The ID of the Subnet."
  value       = azurerm_subnet.this.id
}

output "subnet_name" {
  description = "The name of the Subnet."
  value       = azurerm_subnet.this.name
}

output "address_prefixes" {
  description = "The address prefixes assigned to the Subnet."
  value       = azurerm_subnet.this.address_prefixes
}
