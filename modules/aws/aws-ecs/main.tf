# ECS Cluster Resource
resource "aws_ecs_cluster" "this" {
  count = var.create ? 1 : 0

  name = "${local.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-cluster"
    }
  )
}

# ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "this" {
  count = var.create ? 1 : 0

  cluster_name       = aws_ecs_cluster.this[0].name
  capacity_providers = var.capacity_providers

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

# CloudWatch Log Group for ECS Task Logs
resource "aws_cloudwatch_log_group" "this" {
  count = var.create ? 1 : 0

  name              = "/aws/ecs/${local.name_prefix}"
  retention_in_days = var.log_retention_in_days

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-logs"
    }
  )
}

# ECS Task Definition (Fargate)
resource "aws_ecs_task_definition" "this" {
  count = var.create ? 1 : 0

  family                   = local.name_prefix
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.container_cpu)
  memory                   = tostring(var.container_memory)
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this[0].name
          "awslogs-region"        = data.aws_region.current.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# ECS Service Resource (Private Fargate Placement)
resource "aws_ecs_service" "this" {
  count = var.create ? 1 : 0

  name            = "${local.name_prefix}-service"
  cluster         = aws_ecs_cluster.this[0].id
  task_definition = aws_ecs_task_definition.this[0].arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn != null ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-service"
    }
  )

  depends_on = [aws_ecs_task_definition.this]
}

data "aws_region" "current" {}
