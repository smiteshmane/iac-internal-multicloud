# Trust Policy Document Construction
data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create && var.custom_trust_policy == null ? 1 : 0

  # Service principal assume statements
  dynamic "statement" {
    for_each = length(var.trusted_role_services) > 0 ? [1] : []
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = var.trusted_role_services
      }
    }
  }

  # AWS Cross-Account / User / Role ARNs assume statements
  dynamic "statement" {
    for_each = length(var.trusted_role_arns) > 0 ? [1] : []
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = var.trusted_role_arns
      }
    }
  }

  # OIDC Federated Authentication assume statements
  dynamic "statement" {
    for_each = var.oidc_providers
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type        = "Federated"
        identifiers = [statement.value.provider_arn]
      }

      condition {
        test     = "StringEquals"
        variable = "${replace(statement.value.issuer_url, "https://", "")}:aud"
        values   = statement.value.audiences
      }

      dynamic "condition" {
        for_each = length(statement.value.subjects) > 0 ? [1] : []
        content {
          test     = "StringLike"
          variable = "${replace(statement.value.issuer_url, "https://", "")}:sub"
          values   = statement.value.subjects
        }
      }
    }
  }
}

# IAM Role Resource
resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name                  = local.name_prefix
  description           = var.description
  path                  = var.path
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
  force_detach_policies = var.force_detach_policies

  assume_role_policy = var.custom_trust_policy != null ? var.custom_trust_policy : data.aws_iam_policy_document.assume_role_policy[0].json

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# Managed Policy Attachments
resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.create ? toset(var.managed_policy_arns) : []

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

# Inline Policies
resource "aws_iam_role_policy" "this" {
  for_each = var.create ? var.inline_policies : {}

  name   = each.key
  role   = aws_iam_role.this[0].id
  policy = each.value
}

# IAM Instance Profile (Optional for EC2)
resource "aws_iam_instance_profile" "this" {
  count = var.create && var.create_instance_profile ? 1 : 0

  name = "${local.name_prefix}-profile"
  role = aws_iam_role.this[0].name
  path = var.path

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-profile"
    }
  )
}
