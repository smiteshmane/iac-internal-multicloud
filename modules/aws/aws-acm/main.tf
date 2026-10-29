# ACM Certificate Resource
resource "aws_acm_certificate" "this" {
  count = var.create ? 1 : 0

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
