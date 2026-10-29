# Security Group Resource
resource "aws_security_group" "this" {
  count = var.create ? 1 : 0

  name                   = local.name_prefix
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

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

# Ingress Rules via VPC Security Group Ingress Rule resources
resource "aws_vpc_security_group_ingress_rule" "this" {
  count = var.create ? length(var.ingress_rules) : 0

  security_group_id            = aws_security_group.this[0].id
  description                  = var.ingress_rules[count.index].description
  from_port                    = var.ingress_rules[count.index].protocol == "-1" ? null : var.ingress_rules[count.index].from_port
  to_port                      = var.ingress_rules[count.index].protocol == "-1" ? null : var.ingress_rules[count.index].to_port
  ip_protocol                  = var.ingress_rules[count.index].protocol
  cidr_ipv4                    = length(var.ingress_rules[count.index].cidr_blocks) > 0 ? var.ingress_rules[count.index].cidr_blocks[0] : null
  cidr_ipv6                    = length(var.ingress_rules[count.index].ipv6_cidr_blocks) > 0 ? var.ingress_rules[count.index].ipv6_cidr_blocks[0] : null
  prefix_list_id               = length(var.ingress_rules[count.index].prefix_list_ids) > 0 ? var.ingress_rules[count.index].prefix_list_ids[0] : null
  referenced_security_group_id = var.ingress_rules[count.index].self ? aws_security_group.this[0].id : var.ingress_rules[count.index].source_security_group_id

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-ingress-${count.index + 1}"
    }
  )
}

# Egress Rules via VPC Security Group Egress Rule resources
resource "aws_vpc_security_group_egress_rule" "this" {
  count = var.create ? length(var.egress_rules) : 0

  security_group_id            = aws_security_group.this[0].id
  description                  = var.egress_rules[count.index].description
  from_port                    = var.egress_rules[count.index].protocol == "-1" ? null : var.egress_rules[count.index].from_port
  to_port                      = var.egress_rules[count.index].protocol == "-1" ? null : var.egress_rules[count.index].to_port
  ip_protocol                  = var.egress_rules[count.index].protocol
  cidr_ipv4                    = length(var.egress_rules[count.index].cidr_blocks) > 0 ? var.egress_rules[count.index].cidr_blocks[0] : null
  cidr_ipv6                    = length(var.egress_rules[count.index].ipv6_cidr_blocks) > 0 ? var.egress_rules[count.index].ipv6_cidr_blocks[0] : null
  prefix_list_id               = length(var.egress_rules[count.index].prefix_list_ids) > 0 ? var.egress_rules[count.index].prefix_list_ids[0] : null
  referenced_security_group_id = var.egress_rules[count.index].self ? aws_security_group.this[0].id : var.egress_rules[count.index].destination_security_group_id

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-egress-${count.index + 1}"
    }
  )
}
