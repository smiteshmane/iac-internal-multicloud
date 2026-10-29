# Secret Container Resource
resource "aws_secretsmanager_secret" "this" {
  count = var.create ? 1 : 0

  name                    = local.name_prefix
  description             = var.description
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# Secret Version Payload (If provided)
resource "aws_secretsmanager_secret_version" "this" {
  count = var.create && local.secret_payload != null ? 1 : 0

  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = local.secret_payload
}

# Secret Rotation Configuration
resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.create && var.enable_rotation && var.rotation_lambda_arn != null ? 1 : 0

  secret_id           = aws_secretsmanager_secret.this[0].id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.automatically_after_days
  }
}

# Dynamic Cross-Account Policy Document
data "aws_iam_policy_document" "this" {
  count = var.create && length(var.cross_account_roles) > 0 && var.policy == null ? 1 : 0

  statement {
    sid    = "AllowCrossAccountGetSecretValue"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.cross_account_roles
    }

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [aws_secretsmanager_secret.this[0].arn]
  }
}

# Secret Resource Policy Attachment
resource "aws_secretsmanager_secret_policy" "this" {
  count = var.create && (var.policy != null || length(var.cross_account_roles) > 0) ? 1 : 0

  secret_arn = aws_secretsmanager_secret.this[0].arn
  policy     = var.policy != null ? var.policy : data.aws_iam_policy_document.this[0].json
}
