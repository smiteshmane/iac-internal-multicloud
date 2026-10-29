# GCP Cloud Monitoring & Alerting Terraform Module

Production-ready Terraform module for provisioning Google Cloud Monitoring notification channels (Email) and automated metric alert policies (CPU utilization, Memory usage, 5xx errors, Disk space).

## Features
- **Notification Channels**: Email notification channel creation.
- **Pre-Built VM Alerts**: Automated Compute Engine High CPU Utilization (> 80%) threshold alert policy.
- **Custom Metric Alert Policies**: Dynamic custom metric filter rules and aggregation settings.

## Usage Example

```hcl
module "ops_alerts" {
  source = "./modules/monitoring-alerting"

  project_id                  = "my-gcp-project-123456"
  notification_email_addresses = ["sre-alerts@company.com", "ops-team@company.com"]

  enable_cpu_alert            = true
  cpu_alert_threshold_percent = 85

  alert_policies = [
    {
      display_name    = "Cloud Run 5xx Server Errors"
      filter          = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_count\" AND response_code_class = \"5xx\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 10
    }
  ]
}
```
