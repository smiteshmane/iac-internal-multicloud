locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}-${var.name}"

  default_definition = jsonencode({
    Comment = "Default State Machine"
    StartAt = "PassState"
    States = {
      PassState = {
        Type   = "Pass"
        Result = "Hello from Step Functions!"
        End    = true
      }
    }
  })

  definition = var.definition != null ? var.definition : local.default_definition

  merged_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "aws-step-functions"
    },
    var.common_tags,
    var.tags
  )
}
