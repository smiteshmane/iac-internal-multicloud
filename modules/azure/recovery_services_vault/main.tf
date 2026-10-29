# Azure Recovery Services Vault Module
# Creates a Recovery Services Vault with storage redundancy, soft-delete, and VM backup policies.

resource "azurerm_recovery_services_vault" "this" {
  name                = var.vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  storage_mode_type   = var.storage_mode_type
  soft_delete_enabled = var.soft_delete_enabled

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}

# Optional VM Backup Policy
resource "azurerm_backup_policy_vm" "policies" {
  for_each            = var.backup_policies
  name                = each.key
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  timezone            = lookup(each.value, "timezone", "UTC")

  backup {
    frequency = each.value.backup_frequency
    time      = each.value.backup_time
  }

  retention_daily {
    count = lookup(each.value, "retention_daily_count", 7)
  }
}
