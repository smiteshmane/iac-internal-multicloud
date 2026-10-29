# Azure Cosmos DB Module
# Provisions a Cosmos DB Account with SQL (Core) API, multi-region geo-replication, consistency policies, and containers.

resource "azurerm_cosmosdb_account" "this" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = var.kind

  enable_automatic_failover     = var.enable_automatic_failover
  public_network_access_enabled = var.public_network_access_enabled

  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.consistency_level == "BoundedStaleness" ? var.max_interval_in_seconds : null
    max_staleness_prefix    = var.consistency_level == "BoundedStaleness" ? var.max_staleness_prefix : null
  }

  dynamic "geo_location" {
    for_each = var.geo_locations
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = lookup(geo_location.value, "zone_redundant", false)
    }
  }

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}

# Optional SQL Database
resource "azurerm_cosmosdb_sql_database" "this" {
  count               = var.sql_database_name != null ? 1 : 0
  name                = var.sql_database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.sql_database_throughput
}

# Optional SQL Containers
resource "azurerm_cosmosdb_sql_container" "containers" {
  for_each            = var.sql_containers
  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this[0].name
  partition_key_path  = each.value.partition_key_path
  throughput          = lookup(each.value, "throughput", null)
}
