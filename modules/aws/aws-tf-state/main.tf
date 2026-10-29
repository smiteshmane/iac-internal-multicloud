# S3 Bucket for Terraform Remote State Storage
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

# Versioning (Mandatory for State Recovery)
resource "aws_s3_bucket_versioning" "this" {
  count = var.create ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-Side Encryption Configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.create ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

# Public Access Block (Strictly Enforced)
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.create ? 1 : 0

  bucket                  = aws_s3_bucket.this[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# TLS Transport Policy Enforcement
data "aws_iam_policy_document" "enforce_tls" {
  count = var.create ? 1 : 0

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
  count = var.create ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.enforce_tls[0].json

  depends_on = [aws_s3_bucket_public_access_block.this]
}

# DynamoDB Table for Terraform State Locking
resource "aws_dynamodb_table" "locks" {
  count = var.create ? 1 : 0

  name         = local.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.dynamodb_table_name
    }
  )
}
