# GCP Eventarc Triggers Terraform Module

Production-ready Terraform module for provisioning Google Cloud Eventarc triggers for event-driven architecture, routing Google Cloud Storage object events, Cloud Audit Logs, and Pub/Sub messages directly to Cloud Run services.

## Features
- **Event-Driven Architecture**: Asynchronous routing of GCS, Audit Log, and Pub/Sub events.
- **Cloud Run Destinations**: Seamless event delivery to Cloud Run microservices.
- **Matching Criteria**: Declarative attribute matching rules.

## Usage Example

```hcl
module "gcs_upload_trigger" {
  source = "./modules/eventarc"

  name                  = "prod-gcs-upload-trigger"
  project_id            = "my-gcp-project-123456"
  location              = "us-central1"
  cloud_run_service     = "image-processor-service"
  cloud_run_path        = "/on-upload"
  service_account_email = "eventarc-sa@my-gcp-project-123456.iam.gserviceaccount.com"

  matching_criteria = [
    {
      attribute = "type"
      value     = "google.cloud.storage.object.v1.finalized"
    },
    {
      attribute = "bucket"
      value     = "my-upload-bucket"
    }
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
