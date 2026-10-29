# SSM Parameter Resource
resource "aws_ssm_parameter" "this" {
  count = var.create ? 1 : 0

  name        = local.name_prefix
  description = var.description
  type        = var.type
  value       = var.value
  key_id      = var.type == "SecureString" ? var.key_id : null

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}
