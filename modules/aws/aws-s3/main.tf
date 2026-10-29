# S3 Bucket Resource
resource "aws_s3_bucket" "this" {
  count = var.create ? 1 : 0

  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.bucket_name
    }
  )
}

# Bucket Versioning
resource "aws_s3_bucket_versioning" "this" {
  count = var.create && var.versioning_status != "Disabled" ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status = var.versioning_status
  }
}

# Server-Side Encryption Configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.create ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    bucket_key_enabled = var.bucket_key_enabled

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_master_key_arn : null
    }
  }
}

# Public Access Block Settings (Enterprise Default: All Blocked)
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.create ? 1 : 0

  bucket                  = aws_s3_bucket.this[0].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# Access Logging Configuration
resource "aws_s3_bucket_logging" "this" {
  count = var.create && var.logging_target_bucket != null ? 1 : 0

  bucket        = aws_s3_bucket.this[0].id
  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix
}

# Lifecycle Management Rules
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.create && length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      dynamic "filter" {
        for_each = rule.value.prefix != null ? [1] : []
        content {
          prefix = rule.value.prefix
        }
      }

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration_days != null ? [1] : []
        content {
          days = rule.value.expiration_days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions
        content {
          noncurrent_days = noncurrent_version_transition.value.noncurrent_days
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration_days != null ? [1] : []
        content {
          noncurrent_days = rule.value.noncurrent_version_expiration_days
        }
      }
    }
  }
}

# Enforce TLS Policy & Custom Policy
data "aws_iam_policy_document" "enforce_tls" {
  count = var.create && var.enforce_tls ? 1 : 0

  statement {
    sid    = "EnforceTLSRequestsOnly"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.create && (var.enforce_tls || var.attach_policy) ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = var.custom_bucket_policy != null ? var.custom_bucket_policy : data.aws_iam_policy_document.enforce_tls[0].json

  depends_on = [aws_s3_bucket_public_access_block.this]
}
