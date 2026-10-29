# Azure App Service (Web App + Plan) Module
# Creates a Service Plan (Linux/Windows) and Web App with HTTPS enforcement, Managed Identity, and VNet integration.

resource "azurerm_service_plan" "this" {
  name                = var.app_service_plan_name
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

resource "azurerm_linux_web_app" "linux" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  https_only                = true
  virtual_network_subnet_id = var.vnet_integration_subnet_id

  site_config {
    always_on           = var.always_on
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"

    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        dotnet_version      = application_stack.value.dotnet_version
        node_version        = application_stack.value.node_version
        python_version      = application_stack.value.python_version
        docker_image_name   = application_stack.value.docker_image_name
        docker_registry_url = application_stack.value.docker_registry_url
      }
    }
  }

  app_settings = var.app_settings

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

resource "azurerm_windows_web_app" "windows" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  https_only                = true
  virtual_network_subnet_id = var.vnet_integration_subnet_id

  site_config {
    always_on           = var.always_on
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
  }

  app_settings = var.app_settings

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
