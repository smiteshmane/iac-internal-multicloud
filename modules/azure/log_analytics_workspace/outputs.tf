output "workspace_id" {
  description = "The ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_name" {
  description = "The name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

output "workspace_key" {
  description = "The Primary Shared Key for the Log Analytics Workspace (sensitive)."
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}
