# AWS Secrets Manager Terraform Module

Enterprise Terraform module for provisioning AWS Secrets Manager secrets, version initial payload bootstrapping (raw string or JSON maps), KMS encryption key association, Lambda rotation integration, and cross-account resource policy enforcement.

## Features

- **Flexible Payload Provisioning**: Accepts raw string or JSON map (`secret_key_value`) for automatic structured payload formatting.
- **KMS Integration**: Support for Customer Managed Keys (CMK) encryption.
- **Cross-Account Sharing**: Declarative `cross_account_roles` input generates least-privilege resource policies for cross-account read access.
- **Automated Rotation**: Native integration with Lambda rotation functions.

## Usage Example

```hcl
module "db_secret" {
  source = "../../modules/aws-secrets-manager"

  project     = "acme"
  environment = "prod"
  name        = "db-credentials"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/abc-123"

  secret_key_value = {
    username = "dbadmin"
    password = "SuperSecretPassword123!"
    engine   = "postgres"
    port     = "5432"
  }

  recovery_window_in_days = 30
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether secret should be created | `bool` | `true` | no |
| `project` | Project identifier | `string` | `"enterprise"` | no |
| `environment` | Environment identifier | `string` | n/a | yes |
| `name` | Secret name | `string` | `"app-secret"` | no |
| `kms_key_id` | KMS Key ARN | `string` | `null` | no |
| `secret_key_value` | Key-value map payload | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `secret_arn` | ARN of created secret |
| `secret_id` | ID of created secret |
| `secret_version_id` | Version ID of created payload |
