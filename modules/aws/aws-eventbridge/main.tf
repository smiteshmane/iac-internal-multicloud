# Custom EventBus Resource
resource "aws_cloudwatch_event_bus" "this" {
  count = var.create && var.create_event_bus ? 1 : 0

  name = local.name_prefix

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# Event Rule Resource
resource "aws_cloudwatch_event_rule" "this" {
  count = var.create ? 1 : 0

  name                = "${local.name_prefix}-rule"
  event_bus_name      = var.create_event_bus ? aws_cloudwatch_event_bus.this[0].name : "default"
  schedule_expression = var.schedule_expression
  event_pattern       = var.event_pattern

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-rule"
    }
  )
}

# Event Target Resource
resource "aws_cloudwatch_event_target" "this" {
  count = var.create && var.target_arn != null ? 1 : 0

  rule           = aws_cloudwatch_event_rule.this[0].name
  event_bus_name = var.create_event_bus ? aws_cloudwatch_event_bus.this[0].name : "default"
  arn            = var.target_arn
}
