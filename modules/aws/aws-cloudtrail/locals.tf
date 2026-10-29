locals {
  name_prefix    = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"
  s3_bucket_name = var.s3_bucket_name != null ? var.s3_bucket_name : "${local.name_prefix}-logs"

  default_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws-cloudtrail"
  }

  merged_tags = merge(local.default_tags, var.common_tags, var.tags)
}
