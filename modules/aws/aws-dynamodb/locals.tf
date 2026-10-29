locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"

  merged_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "aws-dynamodb"
    },
    var.common_tags,
    var.tags
  )
}
