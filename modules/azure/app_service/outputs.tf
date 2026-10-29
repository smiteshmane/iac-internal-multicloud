output "app_service_plan_id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_service_plan.this.id
}

output "web_app_id" {
  description = "The ID of the Web App."
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.linux[0].id : azurerm_windows_web_app.windows[0].id
}

output "default_hostname" {
  description = "The default hostname of the Web App."
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.linux[0].default_hostname : azurerm_windows_web_app.windows[0].default_hostname
}

output "principal_id" {
  description = "The System Assigned Identity Principal ID."
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.linux[0].identity[0].principal_id : azurerm_windows_web_app.windows[0].identity[0].principal_id
}
