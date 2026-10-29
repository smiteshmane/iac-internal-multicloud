# Azure Monitor Alert Module
# Creates an Action Group (Email/Webhook) and Metric Alert Rules.

resource "azurerm_monitor_action_group" "this" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = lookup(email_receiver.value, "use_common_alert_schema", true)
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.webhook_receivers
    content {
      name                    = webhook_receiver.value.name
      service_uri             = webhook_receiver.value.service_uri
      use_common_alert_schema = lookup(webhook_receiver.value, "use_common_alert_schema", true)
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

resource "azurerm_monitor_metric_alert" "this" {
  for_each            = var.metric_alerts
  name                = each.key
  resource_group_name = var.resource_group_name
  scopes              = each.value.scopes
  description         = lookup(each.value, "description", "Metric alert rule")
  severity            = lookup(each.value, "severity", 2)
  frequency           = lookup(each.value, "frequency", "PT1M")
  window_size         = lookup(each.value, "window_size", "PT5M")

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}
