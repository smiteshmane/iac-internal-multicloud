# AWS CloudTrail Terraform Module

Enterprise-grade Terraform module for managing AWS CloudTrail audit logs with multi-region event logging, mandatory log file integrity validation, S3 bucket storage policies, CloudWatch Logs delivery, and KMS encryption.

## Features

- **Multi-Region Audit Logging**: Captures management and data events across all AWS regions (`is_multi_region_trail = true`).
- **Integrity Validation**: Enforces log file validation (`enable_log_file_validation = true`) to detect unauthorized log tampering.
- **Dedicated S3 Storage**: Auto-provisions S3 bucket with strict bucket policy granting CloudTrail delivery permissions.
- **CloudWatch Logs Integration**: Stream events to CloudWatch Log Group for real-time security monitoring and alarm triggers.

## Usage Example

```hcl
module "cloudtrail" {
  source = "../../modules/aws-cloudtrail"

  project     = "acme"
  environment = "prod"
  name        = "organization-audit-trail"

  is_multi_region_trail      = true
  enable_log_file_validation = true
  enable_cloudwatch_logs     = true

  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abc-123"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether CloudTrail resources are created | `bool` | `true` | no |
| `project` | Project identifier | `string` | `"enterprise"` | no |
| `environment` | Deployment environment | `string` | n/a | yes |
| `name` | Trail name | `string` | `"audit-trail"` | no |
| `is_multi_region_trail` | Log across all AWS regions | `bool` | `true` | no |
| `enable_log_file_validation` | Enable log integrity validation | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| `trail_arn` | Full ARN of the CloudTrail |
| `trail_id` | Name of the trail |
| `s3_bucket_id` | S3 bucket name storing logs |
| `cloudwatch_log_group_arn` | CloudWatch Log Group ARN |
