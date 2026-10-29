# GCP Cloud Scheduler Cron Terraform Module

Production-ready Terraform module for provisioning Google Cloud Scheduler cron jobs with 5-field cron expressions, timezone control, and secure HTTP OIDC authentication for triggering Cloud Run, Cloud Functions, or internal microservices.

## Features
- **Cron Expressions**: Standard 5-field cron syntax (`0 * * * *`).
- **OIDC Authentication**: Automatic GCP Service Account OIDC bearer token injection for secure microservice invocations.
- **Timezone Aware**: Precise timezone scheduling (UTC, America/New_York, Asia/Kolkata).

## Usage Example

```hcl
module "hourly_cleanup_cron" {
  source = "./modules/cloud-scheduler"

  name        = "prod-hourly-cleanup"
  project_id  = "my-gcp-project-123456"
  region      = "us-central1"
  schedule    = "0 * * * *"
  time_zone   = "UTC"
  description = "Trigger hourly cleanup microservice"

  http_target = {
    uri         = "https://prod-backend-api-xyz.a.run.app/api/v1/cleanup"
    http_method = "POST"
    oidc_token = {
      service_account_email = "scheduler-sa@my-gcp-project-123456.iam.gserviceaccount.com"
    }
  }
}
```
