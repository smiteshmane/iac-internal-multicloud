locals {
  name_prefix    = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"
  log_group_name = var.log_group_name != null ? var.log_group_name : "/aws/app/${local.name_prefix}"

  default_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws-cloudwatch"
  }

  merged_tags = merge(local.default_tags, var.common_tags, var.tags)
}
