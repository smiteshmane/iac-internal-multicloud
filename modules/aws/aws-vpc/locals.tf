locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"

  # Merge standard tags with caller provided tags
  default_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws-vpc"
  }

  merged_tags = merge(local.default_tags, var.common_tags, var.tags)

  # NAT Gateway count logic
  nat_gateway_count = var.create && var.enable_nat_gateway ? (
    var.single_nat_gateway ? 1 : (
      var.one_nat_gateway_per_az ? length(var.azs) : length(var.private_subnets)
    )
  ) : 0

  max_subnet_length = max(
    length(var.public_subnets),
    length(var.private_subnets),
    length(var.database_subnets)
  )
}
