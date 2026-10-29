# GCP Cloud Tasks Queue Terraform Module

Production-ready Terraform module for provisioning Google Cloud Tasks queues with rate limiting (dispatches/sec, concurrency), retry backoff policies, and `roles/cloudtasks.enqueuer` IAM bindings.

## Features
- **Rate Controls**: Fine-grained `max_dispatches_per_second` and `max_concurrent_dispatches` controls.
- **Retry Backoff Policies**: Customizable `min_backoff`, `max_backoff`, and `max_attempts` execution retry policies.
- **IAM Security**: Granular `roles/cloudtasks.enqueuer` bindings for backend microservice service accounts.

## Usage Example

```hcl
module "email_queue" {
  source = "./modules/cloud-tasks"

  queue_name  = "prod-email-notifications"
  project_id  = "my-gcp-project-123456"
  location    = "us-central1"

  max_dispatches_per_second = 100
  max_concurrent_dispatches = 20
  max_attempts              = 5

  queue_enqueuers = [
    "serviceAccount:app-backend-sa@my-gcp-project-123456.iam.gserviceaccount.com"
  ]
}
```
