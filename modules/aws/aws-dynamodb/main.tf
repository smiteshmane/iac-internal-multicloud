# DynamoDB Table Resource
resource "aws_dynamodb_table" "this" {
  count = var.create ? 1 : 0

  name                        = local.name_prefix
  billing_mode                = var.billing_mode
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}
