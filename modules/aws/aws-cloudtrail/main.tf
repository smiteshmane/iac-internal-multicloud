data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

# S3 Bucket for CloudTrail logs (Created if s3_bucket_name is null & create_s3_bucket is true)
resource "aws_s3_bucket" "this" {
  count = var.create && var.s3_bucket_name == null && var.create_s3_bucket ? 1 : 0

  bucket        = local.s3_bucket_name
  force_destroy = false

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.s3_bucket_name
    }
  )
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.create && var.s3_bucket_name == null && var.create_s3_bucket ? 1 : 0

  bucket                  = aws_s3_bucket.this[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.create && var.s3_bucket_name == null && var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.create && var.s3_bucket_name == null && var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

# CloudTrail S3 Bucket Policy Document
data "aws_iam_policy_document" "s3_policy" {
  count = var.create && var.s3_bucket_name == null && var.create_s3_bucket ? 1 : 0

  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.this[0].arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this[0].arn}/${var.s3_key_prefix}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.create && var.s3_bucket_name == null && var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.s3_policy[0].json

  depends_on = [aws_s3_bucket_public_access_block.this]
}

# CloudWatch Log Group for Trail Events
resource "aws_cloudwatch_log_group" "this" {
  count = var.create && var.enable_cloudwatch_logs ? 1 : 0

  name              = "/aws/cloudtrail/${local.name_prefix}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.kms_key_arn

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-cw-lg"
    }
  )
}

# IAM Role for CloudWatch Logs Delivery
resource "aws_iam_role" "cloudwatch" {
  count = var.create && var.enable_cloudwatch_logs ? 1 : 0

  name = "${local.name_prefix}-cw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })

  tags = local.merged_tags
}

resource "aws_iam_role_policy" "cloudwatch" {
  count = var.create && var.enable_cloudwatch_logs ? 1 : 0

  name = "${local.name_prefix}-cw-policy"
  role = aws_iam_role.cloudwatch[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.this[0].arn}:*"
      }
    ]
  })
}

# AWS CloudTrail Resource
resource "aws_cloudtrail" "this" {
  count = var.create ? 1 : 0

  name                          = local.name_prefix
  s3_bucket_name                = var.s3_bucket_name != null ? var.s3_bucket_name : aws_s3_bucket.this[0].id
  s3_key_prefix                 = var.s3_key_prefix
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  enable_log_file_validation    = var.enable_log_file_validation
  kms_key_id                    = var.kms_key_arn
  enable_logging                = var.enable_logging
  is_organization_trail         = var.is_organization_trail

  cloud_watch_logs_group_arn = var.enable_cloudwatch_logs ? "${aws_cloudwatch_log_group.this[0].arn}:*" : null
  cloud_watch_logs_role_arn  = var.enable_cloudwatch_logs ? aws_iam_role.cloudwatch[0].arn : null

  dynamic "event_selector" {
    for_each = var.event_selectors
    content {
      read_write_type           = event_selector.value.read_write_type
      include_management_events = event_selector.value.include_management_events

      dynamic "data_resource" {
        for_each = event_selector.value.data_resources
        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )

  depends_on = [aws_s3_bucket_policy.this]
}
