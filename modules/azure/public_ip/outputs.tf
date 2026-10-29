output "public_ip_id" {
  description = "The ID of the Public IP."
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "The assigned IP address."
  value       = azurerm_public_ip.this.ip_address
}

output "fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the Public IP."
  value       = azurerm_public_ip.this.fqdn
}
