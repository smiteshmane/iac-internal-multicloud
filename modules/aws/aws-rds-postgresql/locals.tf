locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"

  default_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws-rds-postgresql"
  }

  merged_tags = merge(local.default_tags, var.common_tags, var.tags)

  # Mandatory security parameter for PostgreSQL: enforce SSL connections
  default_postgres_parameters = [
    {
      name         = "rds.force_ssl"
      value        = "1"
      apply_method = "immediate"
    }
  ]

  all_parameters = concat(local.default_postgres_parameters, var.parameters)
}
