output "function_app_id" {
  description = "The ID of the Function App."
  value       = azurerm_linux_function_app.linux[0].id
}

output "function_app_name" {
  description = "The name of the Function App."
  value       = azurerm_linux_function_app.linux[0].name
}

output "default_hostname" {
  description = "The default hostname of the Function App."
  value       = azurerm_linux_function_app.linux[0].default_hostname
}

output "principal_id" {
  description = "The System Assigned Identity Principal ID."
  value       = azurerm_linux_function_app.linux[0].identity[0].principal_id
}
