# SNS Topic Resource
resource "aws_sns_topic" "this" {
  count = var.create && var.enable_sns_topic ? 1 : 0

  name              = "${local.name_prefix}-topic"
  kms_master_key_id = "alias/aws/sns"

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-topic"
    }
  )
}

# Dead Letter Queue (DLQ)
resource "aws_sqs_queue" "dlq" {
  count = var.create && var.enable_sqs_queue && var.enable_dlq ? 1 : 0

  name                      = "${local.name_prefix}-dlq"
  kms_master_key_id         = "alias/aws/sqs"
  message_retention_seconds = 1209600 # 14 days

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-dlq"
    }
  )
}

# Primary SQS Queue
resource "aws_sqs_queue" "this" {
  count = var.create && var.enable_sqs_queue ? 1 : 0

  name                      = "${local.name_prefix}-queue"
  kms_master_key_id         = "alias/aws/sqs"
  message_retention_seconds = 345600 # 4 days

  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-queue"
    }
  )
}

# SQS Queue Policy allowing SNS Topic to send messages
resource "aws_sqs_queue_policy" "this" {
  count = var.create && var.enable_sqs_queue && var.enable_sns_topic && var.subscribe_sqs_to_sns ? 1 : 0

  queue_url = aws_sqs_queue.this[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSNSSendMessage"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.this[0].arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.this[0].arn
          }
        }
      }
    ]
  })
}

# SNS Subscription to SQS Queue
resource "aws_sns_topic_subscription" "this" {
  count = var.create && var.enable_sqs_queue && var.enable_sns_topic && var.subscribe_sqs_to_sns ? 1 : 0

  topic_arn = aws_sns_topic.this[0].arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this[0].arn
}
