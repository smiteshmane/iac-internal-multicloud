# Azure Load Balancer Module
# Supports Public or Internal Standard Load Balancers with Backend Pools, Probes, and Rules.

resource "azurerm_lb" "this" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = var.frontend_ip_name
    public_ip_address_id          = var.public_ip_address_id
    subnet_id                     = var.subnet_id
    private_ip_address            = var.private_ip_address
    private_ip_address_allocation = var.subnet_id != null ? var.private_ip_address_allocation : null
  }

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}

resource "azurerm_lb_backend_address_pool" "this" {
  name            = var.backend_pool_name
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "this" {
  for_each        = { for probe in var.probes : probe.name => probe }
  name            = each.value.name
  loadbalancer_id = azurerm_lb.this.id
  protocol        = lookup(each.value, "protocol", "Tcp")
  port            = each.value.port
  request_path    = lookup(each.value, "request_path", null)
}

resource "azurerm_lb_rule" "this" {
  for_each                       = { for rule in var.lb_rules : rule.name => rule }
  name                           = each.value.name
  loadbalancer_id                = azurerm_lb.this.id
  frontend_ip_configuration_name = var.frontend_ip_name
  protocol                       = lookup(each.value, "protocol", "Tcp")
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  probe_id                       = lookup(azurerm_lb_probe.this, each.value.probe_name, null) != null ? azurerm_lb_probe.this[each.value.probe_name].id : null
}
