data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# Dynamic KMS Key Policy Generation
data "aws_iam_policy_document" "this" {
  count = var.create && var.custom_key_policy == null ? 1 : 0

  # Root Account Permissions (Required for KMS Policy administration via IAM)
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Key Owners Statement
  dynamic "statement" {
    for_each = length(var.key_owners) > 0 ? [1] : []
    content {
      sid    = "Allow Key Administration"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.key_owners
      }
      actions = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]
      resources = ["*"]
    }
  }

  # Key Users Cryptographic Access
  dynamic "statement" {
    for_each = length(var.key_users) > 0 ? [1] : []
    content {
      sid    = "Allow Cryptographic Operations"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.key_users
      }
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = ["*"]
    }
  }

  # AWS Service Principals Access
  dynamic "statement" {
    for_each = length(var.key_service_principals) > 0 ? [1] : []
    content {
      sid    = "Allow AWS Services Use"
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = var.key_service_principals
      }
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = ["*"]
    }
  }
}

# KMS Key Resource
resource "aws_kms_key" "this" {
  count = var.create ? 1 : 0

  description              = var.description
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  is_enabled               = var.is_enabled
  multi_region             = var.multi_region
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec

  policy = var.custom_key_policy != null ? var.custom_key_policy : data.aws_iam_policy_document.this[0].json

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# KMS Key Alias Resource
resource "aws_kms_alias" "this" {
  count = var.create ? 1 : 0

  name          = local.alias_name
  target_key_id = aws_kms_key.this[0].key_id
}
