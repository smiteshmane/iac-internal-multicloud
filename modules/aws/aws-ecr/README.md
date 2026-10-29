# AWS ECR Terraform Module

Enterprise-grade Terraform module for managing AWS Elastic Container Registry (ECR) repositories with mandatory image scanning, tag immutability, KMS encryption, automated lifecycle policies, and cross-account repository policies.

## Features

- **Tag Immutability**: Configured with `image_tag_mutability = "IMMUTABLE"` by default to prevent image tag overwriting in production.
- **Automated Scanning**: Enables vulnerability scanning on image push (`scan_on_push = true`).
- **Lifecycle Engine**: Automatically purges untagged images older than 14 days and enforces maximum image retention limits.
- **Repository Access Policies**: Declarative input for read (pull) and read-write (push/pull) IAM ARNs across accounts.

## Usage Example

```hcl
module "ecr" {
  source = "../../modules/aws-ecr"

  project     = "acme"
  environment = "prod"
  name        = "microservice-api"

  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true

  max_untagged_image_age_days = 7
  max_tagged_image_count      = 50

  read_access_arns = [
    "arn:aws:iam::123456789012:role/EKSWorkerNodeRole"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether ECR resources are created | `bool` | `true` | no |
| `project` | Project name | `string` | `"enterprise"` | no |
| `environment` | Deployment environment | `string` | n/a | yes |
| `name` | Repository name | `string` | `"app-repo"` | no |
| `image_tag_mutability` | Tag mutability (IMMUTABLE/MUTABLE) | `string` | `"IMMUTABLE"` | no |
| `scan_on_push` | Scan images on push | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| `repository_arn` | Full ARN of the ECR repository |
| `repository_name` | Name of the repository |
| `repository_url` | Full repository URL |
