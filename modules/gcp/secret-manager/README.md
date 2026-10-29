# GCP Secret Manager Terraform Module

Production-ready Terraform module for provisioning Google Cloud Secret Manager secrets with automatic/user-managed replication, CMEK encryption, initial secret version payloads, and IAM secret accessor bindings.

## Features
- **Replication**: Automatic global replication or targeted multi-region replication.
- **CMEK Encryption**: Optional Cloud KMS Customer-Managed Encryption Key support.
- **Payload Management**: Optional sensitive initial secret payload version creation.
- **Rotation Policies**: Automatic secret rotation schedules.
- **IAM Access Controls**: Fine-grained `roles/secretmanager.secretAccessor` assignments for service accounts.

## Usage Example

```hcl
module "db_password_secret" {
  source = "./modules/secret-manager"

  secret_id   = "prod-db-password"
  project_id  = "my-gcp-project-123456"
  secret_data = var.database_password

  secret_accessors = [
    "serviceAccount:app-backend-sa@my-gcp-project-123456.iam.gserviceaccount.com"
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
    security    = "high"
  }
}
```
