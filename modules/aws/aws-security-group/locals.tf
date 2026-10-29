locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"

  default_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws-security-group"
  }

  merged_tags = merge(local.default_tags, var.common_tags, var.tags)
}
