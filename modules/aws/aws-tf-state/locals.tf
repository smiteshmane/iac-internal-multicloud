locals {
  name_prefix         = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"
  bucket_name         = var.bucket_name != null ? var.bucket_name : "${local.name_prefix}-bucket"
  dynamodb_table_name = var.dynamodb_table_name != null ? var.dynamodb_table_name : "${local.name_prefix}-locks"

  default_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws-tf-state"
  }

  merged_tags = merge(local.default_tags, var.common_tags, var.tags)
}
