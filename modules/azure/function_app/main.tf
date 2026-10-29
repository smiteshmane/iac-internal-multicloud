# Azure Function App Module
# Creates an Azure Linux/Windows Function App with dedicated Storage Account binding and Application Insights.

resource "azurerm_service_plan" "this" {
  count               = var.service_plan_id == null ? 1 : 0
  name                = "${var.function_app_name}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}

resource "azurerm_linux_function_app" "linux" {
  count                       = var.os_type == "Linux" ? 1 : 0
  name                        = var.function_app_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = var.service_plan_id != null ? var.service_plan_id : azurerm_service_plan.this[0].id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = var.storage_account_access_key
  https_only                  = true
  virtual_network_subnet_id   = var.vnet_integration_subnet_id

  site_config {
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"

    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        dotnet_version = application_stack.value.dotnet_version
        node_version   = application_stack.value.node_version
        python_version = application_stack.value.python_version
      }
    }
  }

  app_settings = merge(
    {
      "APPINSIGHTS_INSTRUMENTATIONKEY" = var.application_insights_key
    },
    var.app_settings
  )

  identity {
    type = var.identity_type
  }

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}
