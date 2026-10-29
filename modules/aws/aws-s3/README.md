# AWS S3 Terraform Module

Production-grade Terraform module to create Amazon S3 buckets enforcing AWS security controls, server-side KMS encryption, public access block defaults, bucket versioning, object lifecycle rules, and TLS transport policy enforcement.

## Features

- **Public Access Blocked**: Enables all 4 S3 public access block flags by default.
- **Encryption by Default**: Supports SSE-KMS and SSE-S3 (`AES256`) with optional Bucket Keys.
- **HTTPS/TLS Enforcement**: Auto-attaches a bucket policy denying unencrypted `http://` transport requests (`aws:SecureTransport = false`).
- **Lifecycle Engine**: Custom rules for object tiering (Standard-IA, Glacier) and noncurrent version expiration.
- **Access Logging**: Easily attach target bucket logging for compliance auditing.

## Usage Example

```hcl
module "s3_data_bucket" {
  source = "../../modules/aws-s3"

  project     = "acme"
  environment = "prod"
  name        = "app-data-storage"

  versioning_status  = "Enabled"
  sse_algorithm      = "aws:kms"
  kms_master_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abc-123"

  lifecycle_rules = [
    {
      id      = "archive-old-objects"
      enabled = true
      prefix  = "logs/"
      transitions = [
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
      expiration_days = 365
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether to create S3 resources | `bool` | `true` | no |
| `project` | Project identifier | `string` | `"enterprise"` | no |
| `environment` | Deployment environment | `string` | n/a | yes |
| `name` | Bucket name identifier | `string` | `"bucket"` | no |
| `versioning_status` | Versioning status (Enabled/Suspended/Disabled) | `string` | `"Enabled"` | no |
| `sse_algorithm` | Encryption algorithm (aws:kms/AES256) | `string` | `"aws:kms"` | no |
| `kms_master_key_arn` | KMS key ARN for SSE-KMS | `string` | `null` | no |
| `enforce_tls` | Enforce TLS requests via bucket policy | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | S3 bucket name |
| `bucket_arn` | S3 bucket ARN |
| `bucket_domain_name` | S3 bucket domain name |
