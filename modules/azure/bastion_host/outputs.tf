output "bastion_host_id" {
  description = "The ID of the Azure Bastion Host."
  value       = azurerm_bastion_host.this.id
}

output "bastion_host_name" {
  description = "The name of the Azure Bastion Host."
  value       = azurerm_bastion_host.this.name
}

output "dns_name" {
  description = "The FQDN DNS name of the Azure Bastion Host."
  value       = azurerm_bastion_host.this.dns_name
}
