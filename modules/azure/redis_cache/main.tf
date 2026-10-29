# Azure Cache for Redis Module
# Provisions an Azure Redis Cache instance (Basic, Standard, Premium SKU) with TLS 1.2 minimum, subnet integration (Premium), and firewall rules.

resource "azurerm_redis_cache" "this" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  enable_non_ssl_port = var.enable_non_ssl_port
  minimum_tls_version = "1.2"
  subnet_id           = var.sku_name == "Premium" ? var.subnet_id : null

  redis_configuration {
    maxmemory_reserved = var.sku_name != "Basic" ? var.maxmemory_reserved : null
    maxmemory_delta    = var.sku_name != "Basic" ? var.maxmemory_delta : null
    maxmemory_policy   = var.maxmemory_policy
  }

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}

# Optional Redis Firewall Rules
resource "azurerm_redis_firewall_rule" "rules" {
  for_each            = var.firewall_rules
  name                = each.key
  redis_cache_name    = azurerm_redis_cache.this.name
  resource_group_name = var.resource_group_name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}
