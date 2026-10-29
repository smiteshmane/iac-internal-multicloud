# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "this" {
  count = var.create ? 1 : 0

  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = local.merged_tags
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "this" {
  count = var.create ? 1 : 0

  name   = "${local.name_prefix}-params"
  family = "redis7"

  tags = local.merged_tags
}

# ElastiCache Redis Replication Group
resource "aws_elasticache_replication_group" "this" {
  count = var.create ? 1 : 0

  replication_group_id = local.name_prefix
  description          = "Redis replication group for ${local.name_prefix}"
  node_type            = var.node_type
  num_cache_clusters   = var.num_cache_clusters
  port                 = var.port

  engine               = "redis"
  engine_version       = var.engine_version
  subnet_group_name    = aws_elasticache_subnet_group.this[0].name
  parameter_group_name = aws_elasticache_parameter_group.this[0].name
  security_group_ids   = var.security_group_ids

  transit_encryption_enabled = var.transit_encryption_enabled
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  automatic_failover_enabled = var.automatic_failover_enabled

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}
