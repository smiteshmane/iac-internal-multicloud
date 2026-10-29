output "vault_id" {
  description = "The ID of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.id
}

output "vault_name" {
  description = "The name of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.name
}

output "backup_policy_ids" {
  description = "Map of created backup policy names and IDs."
  value       = { for k, v in azurerm_backup_policy_vm.policies : k => v.id }
}
