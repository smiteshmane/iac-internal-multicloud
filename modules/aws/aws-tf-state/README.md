# AWS Terraform Remote State & Locking Module

Enterprise-grade Terraform module to provision production-ready remote state backends consisting of an encrypted, versioned Amazon S3 bucket for state file storage and an Amazon DynamoDB table for state locking.

## Features

- **Mandatory Versioning**: Enforces `versioning { status = "Enabled" }` on the S3 bucket for point-in-time state file recovery.
- **State Locking**: Creates a DynamoDB table with `LockID` primary key using `PAY_PER_REQUEST` billing mode to prevent concurrent state modifications.
- **Security Hardening**: Enforces TLS/SSL transport policy (`aws:SecureTransport = false` deny rule), all 4 S3 Public Access Block settings, and server-side encryption.
- **Backend Snippet Generator**: Outputs ready-to-use HCL `backend "s3"` configuration blocks.

## Usage Example

```hcl
module "tf_state" {
  source = "../../modules/aws-tf-state"

  project     = "acme"
  environment = "prod"
  name        = "backend-state"

  kms_key_arn   = "arn:aws:kms:us-east-1:123456789012:key/abc-123"
  force_destroy = false
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether state resources are created | `bool` | `true` | no |
| `project` | Project name | `string` | `"enterprise"` | no |
| `environment` | Deployment environment | `string` | n/a | yes |
| `name` | Resource name identifier | `string` | `"tf-state"` | no |
| `kms_key_arn` | KMS key ARN for encryption | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `s3_bucket_id` | Name of state S3 bucket |
| `dynamodb_table_name` | Name of state lock DynamoDB table |
| `backend_config` | Terraform `backend "s3"` HCL code snippet |
