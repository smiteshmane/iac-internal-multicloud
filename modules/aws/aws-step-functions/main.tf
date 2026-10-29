# IAM Role for Step Functions
resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name = "${local.name_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })

  tags = local.merged_tags
}

# Step Functions State Machine Resource
resource "aws_sfn_state_machine" "this" {
  count = var.create ? 1 : 0

  name       = local.name_prefix
  role_arn   = aws_iam_role.this[0].arn
  type       = var.type
  definition = local.definition

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}
