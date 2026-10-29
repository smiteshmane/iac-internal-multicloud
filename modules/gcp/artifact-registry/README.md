# GCP Artifact Registry Terraform Module

Production-ready Terraform module for provisioning Google Cloud Artifact Registry package and container repositories (Docker, Maven, npm, Python, Helm) with CMEK encryption, dynamic tag cleanup policies, and IAM role bindings.

## Features
- **Multi-Format Support**: Docker, Maven, npm, Python, Helm repositories.
- **Security & CMEK**: Optional Cloud KMS Customer-Managed Encryption Key integration.
- **Tag Retention & Cleanup**: Dynamic cleanup policy rules for automatic stale image deletion.
- **IAM Access Control**: Granular IAM member bindings for service accounts and developer roles.

## Usage Example

```hcl
module "docker_repo" {
  source = "./modules/artifact-registry"

  repository_id = "prod-app-containers"
  project_id    = "my-gcp-project-123456"
  location      = "us-central1"
  format        = "DOCKER"
  description   = "Production Docker container image repository"

  cleanup_policies = [
    {
      id     = "delete-untagged-images"
      action = "DELETE"
      condition = {
        tag_state  = "UNTAGGED"
        older_than = "604800s" # 7 days
      }
    }
  ]

  iam_members = [
    {
      role   = "roles/artifactregistry.writer"
      member = "serviceAccount:ci-cd-sa@my-gcp-project-123456.iam.gserviceaccount.com"
    }
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
