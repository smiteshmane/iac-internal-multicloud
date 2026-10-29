output "vm_id" {
  description = "The ID of the Virtual Machine."
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.linux[0].id : azurerm_windows_virtual_machine.windows[0].id
}

output "nic_id" {
  description = "The ID of the Network Interface."
  value       = azurerm_network_interface.this.id
}

output "private_ip_address" {
  description = "The Private IP address of the VM."
  value       = azurerm_network_interface.this.private_ip_address
}

output "principal_id" {
  description = "The System Assigned Managed Identity Principal ID of the VM."
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.linux[0].identity[0].principal_id : azurerm_windows_virtual_machine.windows[0].identity[0].principal_id
}
