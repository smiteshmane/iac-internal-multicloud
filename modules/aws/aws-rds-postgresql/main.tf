resource "random_password" "master_password" {
  count = var.create && var.password == null ? 1 : 0

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "this" {
  count = var.create && length(var.subnet_ids) > 0 ? 1 : 0

  name        = "${local.name_prefix}-subnet-group"
  description = "Database subnet group for ${local.name_prefix}"
  subnet_ids  = var.subnet_ids

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-subnet-group"
    }
  )
}

resource "aws_db_parameter_group" "this" {
  count = var.create ? 1 : 0

  name        = "${local.name_prefix}-pg"
  family      = var.parameter_group_family
  description = "PostgreSQL custom parameter group for ${local.name_prefix}"

  dynamic "parameter" {
    for_each = local.all_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-pg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  count = var.create && var.monitoring_interval > 0 ? 1 : 0

  name = "${local.name_prefix}-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = local.merged_tags
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.create && var.monitoring_interval > 0 ? 1 : 0

  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "this" {
  count = var.create ? 1 : 0

  identifier = local.name_prefix

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id

  db_name  = var.db_name
  username = var.username
  password = var.password != null ? var.password : random_password.master_password[0].result
  port     = var.port

  multi_az               = var.multi_az
  db_subnet_group_name   = try(aws_db_subnet_group.this[0].name, null)
  vpc_security_group_ids = var.vpc_security_group_ids
  parameter_group_name   = aws_db_parameter_group.this[0].name

  publicly_accessible       = var.publicly_accessible
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${local.name_prefix}-final-snapshot"

  backup_retention_period = var.backup_retention_period

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? aws_iam_role.enhanced_monitoring[0].arn : null

  performance_insights_enabled = var.performance_insights_enabled

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )

  lifecycle {
    ignore_changes = [password]
  }
}
