output "action_group_id" {
  description = "The ID of the Monitor Action Group."
  value       = azurerm_monitor_action_group.this.id
}

output "action_group_name" {
  description = "The name of the Monitor Action Group."
  value       = azurerm_monitor_action_group.this.name
}

output "metric_alert_ids" {
  description = "Map of created metric alert names and IDs."
  value       = { for k, v in azurerm_monitor_metric_alert.this : k => v.id }
}
