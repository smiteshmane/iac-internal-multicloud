# Azure Log Analytics Workspace Module
# Provisions a Log Analytics Workspace with custom retention policies, SKU configuration, and optional solutions.

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  daily_quota_gb      = var.daily_quota_gb

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}

# Optional Log Analytics Solutions (e.g. ContainerInsights, Security)
resource "azurerm_log_analytics_solution" "solutions" {
  for_each              = var.solutions
  solution_name         = each.key
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = each.value.publisher
    product   = each.value.product
  }
}
