locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"
  bucket_name = var.bucket_name != null ? var.bucket_name : local.name_prefix

  default_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws-s3"
  }

  merged_tags = merge(local.default_tags, var.common_tags, var.tags)
}
