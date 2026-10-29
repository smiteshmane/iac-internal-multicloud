# GCP Service Account & Workload Identity Terraform Module

Production-ready Terraform module for provisioning Google Cloud Service Accounts, project IAM role assignments, and Workload Identity User bindings (for GKE Kubernetes Service Accounts & GitHub Actions keyless OIDC).

## Features
- **Service Account Management**: Lifecycle management for GCP Service Accounts.
- **IAM Role Assignments**: Declarative project-level IAM role bindings.
- **Workload Identity**: Native `roles/iam.workloadIdentityUser` bindings for GKE pods and GitHub Actions.

## Usage Example

```hcl
module "app_sa" {
  source = "./modules/iam-service-account"

  account_id   = "prod-app-backend"
  project_id   = "my-gcp-project-123456"
  display_name = "Production App Backend Service Account"
  description  = "Service account used by backend microservices"

  project_roles = [
    "roles/storage.objectViewer",
    "roles/secretmanager.secretAccessor"
  ]

  workload_identity_users = [
    "serviceAccount:my-gcp-project-123456.svc.id.goog[production/backend-ksa]"
  ]
}
```
