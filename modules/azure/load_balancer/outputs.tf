output "lb_id" {
  description = "The ID of the Load Balancer."
  value       = azurerm_lb.this.id
}

output "lb_frontend_ip_config" {
  description = "The Frontend IP configuration block."
  value       = azurerm_lb.this.frontend_ip_configuration
}

output "backend_address_pool_id" {
  description = "The ID of the Backend Address Pool."
  value       = azurerm_lb_backend_address_pool.this.id
}
