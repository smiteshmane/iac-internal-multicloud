output "vmss_id" {
  description = "The ID of the Virtual Machine Scale Set."
  value       = azurerm_linux_virtual_machine_scale_set.this.id
}

output "vmss_name" {
  description = "The name of the Virtual Machine Scale Set."
  value       = azurerm_linux_virtual_machine_scale_set.this.name
}

output "principal_id" {
  description = "The System Assigned Managed Identity Principal ID of the VMSS."
  value       = azurerm_linux_virtual_machine_scale_set.this.identity[0].principal_id
}
