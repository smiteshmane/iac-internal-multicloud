# AWS KMS Terraform Module

Enterprise-grade Terraform module for managing AWS Key Management Service (KMS) Customer Managed Keys (CMK) with automatic annual key rotation, granular key policies, aliases, and multi-region replication capabilities.

## Features

- **Security Defaults**: Enables automatic key rotation (`enable_key_rotation = true`) by default.
- **Least-Privilege Key Policy**: Generates compliant KMS policy statements for account root, key admins, key users, and AWS service principals.
- **Alias Creation**: Automated creation of formatted key aliases (`alias/<project>-<environment>-<name>`).
- **Multi-Region Support**: Option for multi-Region primary KMS key creation (`multi_region = true`).

## Usage Example

```hcl
module "s3_kms_key" {
  source = "../../modules/aws-kms"

  project     = "acme"
  environment = "prod"
  name        = "s3-encryption-key"
  description = "KMS Customer Managed Key for S3 bucket server-side encryption"

  enable_key_rotation     = true
  deletion_window_in_days = 30

  key_service_principals = [
    "s3.amazonaws.com"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether KMS resources should be created | `bool` | `true` | no |
| `project` | Project name | `string` | `"enterprise"` | no |
| `environment` | Deployment environment | `string` | n/a | yes |
| `name` | Key name identifier | `string` | `"key"` | no |
| `enable_key_rotation` | Enable annual key rotation | `bool` | `true` | no |
| `deletion_window_in_days` | Deletion delay window in days | `number` | `30` | no |
| `key_service_principals` | List of AWS services granted key access | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `key_arn` | The Amazon Resource Name (ARN) of the key |
| `key_id` | The globally unique identifier for the key |
| `alias_arn` | The ARN of the key alias |
| `alias_name` | The name of the key alias |
