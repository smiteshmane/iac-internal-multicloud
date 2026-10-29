# Route 53 Hosted Zone Resource
resource "aws_route53_zone" "this" {
  count = var.create ? 1 : 0

  name = var.domain_name

  dynamic "vpc" {
    for_each = var.private_zone && var.vpc_id != null ? [1] : []
    content {
      vpc_id = var.vpc_id
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-${var.domain_name}"
    }
  )
}

# Route 53 DNS Records
resource "aws_route53_record" "this" {
  count = var.create ? length(var.records) : 0

  zone_id = aws_route53_zone.this[0].zone_id
  name    = var.records[count.index].name
  type    = var.records[count.index].type
  ttl     = var.records[count.index].alias == null ? var.records[count.index].ttl : null
  records = var.records[count.index].alias == null ? var.records[count.index].records : null

  dynamic "alias" {
    for_each = var.records[count.index].alias != null ? [var.records[count.index].alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
