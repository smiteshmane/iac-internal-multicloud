locals {
  name_prefix = "${var.project}-${var.environment}"

  merged_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "aws-route53"
    },
    var.common_tags,
    var.tags
  )
}
