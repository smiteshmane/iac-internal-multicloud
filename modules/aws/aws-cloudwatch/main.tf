# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  count = var.create && var.create_log_group ? 1 : 0

  name              = local.log_group_name
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.log_group_name
    }
  )
}

# SNS Topic for Alarms
resource "aws_sns_topic" "alarms" {
  count = var.create && var.create_sns_topic ? 1 : 0

  name = "${local.name_prefix}-alarm-topic"

  kms_master_key_id = var.kms_key_id != null ? var.kms_key_id : "alias/aws/sns"

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-alarm-topic"
    }
  )
}

# SNS Subscriptions
resource "aws_sns_topic_subscription" "this" {
  for_each = var.create && var.create_sns_topic ? var.sns_subscriptions : {}

  topic_arn = aws_sns_topic.alarms[0].arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}

# Metric Alarms
resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = var.create ? var.metric_alarms : {}

  alarm_name          = "${local.name_prefix}-${each.key}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description
  dimensions          = each.value.dimensions

  alarm_actions = var.create_sns_topic ? [aws_sns_topic.alarms[0].arn] : []
  ok_actions    = var.create_sns_topic ? [aws_sns_topic.alarms[0].arn] : []

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-${each.key}"
    }
  )
}

# Composite Alarms
resource "aws_cloudwatch_composite_alarm" "this" {
  for_each = var.create ? var.composite_alarms : {}

  alarm_name        = "${local.name_prefix}-${each.key}"
  alarm_rule        = each.value.alarm_rule
  alarm_description = each.value.alarm_description

  alarm_actions = var.create_sns_topic ? [aws_sns_topic.alarms[0].arn] : []
  ok_actions    = var.create_sns_topic ? [aws_sns_topic.alarms[0].arn] : []

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-${each.key}"
    }
  )
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "this" {
  count = var.create && var.create_dashboard && var.dashboard_body != null ? 1 : 0

  dashboard_name = local.name_prefix
  dashboard_body = var.dashboard_body
}
