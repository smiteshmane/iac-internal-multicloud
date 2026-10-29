resource "google_monitoring_notification_channel" "email" {
  for_each     = toset(var.notification_email_addresses)
  project      = var.project_id
  display_name = "Email Notification - ${each.value}"
  type         = "email"

  labels = {
    email_address = each.value
  }
}

resource "google_monitoring_alert_policy" "high_cpu" {
  count        = var.enable_cpu_alert ? 1 : 0
  project      = var.project_id
  display_name = "High CPU Utilization Alert (> ${var.cpu_alert_threshold_percent}%)"
  combiner     = "OR"
  user_labels  = local.user_labels

  notification_channels = [for channel in google_monitoring_notification_channel.email : channel.name]

  conditions {
    display_name = "VM CPU Utilization > ${var.cpu_alert_threshold_percent}%"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.cpu_alert_threshold_percent / 100

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}

resource "google_monitoring_alert_policy" "custom" {
  for_each     = { for policy in var.alert_policies : policy.display_name => policy }
  project      = var.project_id
  display_name = each.value.display_name
  combiner     = each.value.combiner
  user_labels  = local.user_labels

  notification_channels = [for channel in google_monitoring_notification_channel.email : channel.name]

  conditions {
    display_name = each.value.display_name

    condition_threshold {
      filter          = each.value.filter
      duration        = each.value.duration
      comparison      = each.value.comparison
      threshold_value = each.value.threshold_value

      aggregations {
        alignment_period     = each.value.alignment_period
        per_series_aligner   = each.value.per_series_aligner
        cross_series_reducer = each.value.cross_series_reducer
      }
    }
  }
}
