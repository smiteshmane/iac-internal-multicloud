output "notification_channel_names" {
  description = "List of created notification channel resource names."
  value       = [for channel in google_monitoring_notification_channel.email : channel.name]
}

output "high_cpu_alert_name" {
  description = "The resource name of the High CPU alert policy."
  value       = length(google_monitoring_alert_policy.high_cpu) > 0 ? google_monitoring_alert_policy.high_cpu[0].name : null
}
