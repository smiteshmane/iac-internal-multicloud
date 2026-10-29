locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"
  alias_name  = var.alias_name != "" ? var.alias_name : "alias/${local.name_prefix}"

  default_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws-kms"
  }

  merged_tags = merge(local.default_tags, var.common_tags, var.tags)
}
