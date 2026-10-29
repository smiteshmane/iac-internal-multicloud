# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "this" {
  count = var.create ? 1 : 0

  name              = "/aws/lambda/${local.name_prefix}"
  retention_in_days = var.log_retention_in_days

  tags = local.merged_tags
}

# IAM Role for Lambda Function
resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name = "${local.name_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = local.merged_tags
}

# Attach Basic Execution Policy
resource "aws_iam_role_policy_attachment" "basic_execution" {
  count = var.create ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach VPC Access Policy if in VPC
resource "aws_iam_role_policy_attachment" "vpc_access" {
  count = var.create && length(var.subnet_ids) > 0 ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Dummy ZIP archive for bootstrap
data "archive_file" "bootstrap" {
  type        = "zip"
  output_path = "${path.module}/bootstrap.zip"

  source {
    content  = "def handler(event, context):\n    return {'statusCode': 200, 'body': 'Hello World'}"
    filename = "index.py"
  }
}

# Lambda Function Resource
resource "aws_lambda_function" "this" {
  count = var.create ? 1 : 0

  function_name = local.name_prefix
  description   = var.description
  role          = aws_iam_role.this[0].arn
  runtime       = var.runtime
  handler       = var.handler
  memory_size   = var.memory_size
  timeout       = var.timeout

  filename         = data.archive_file.bootstrap.output_path
  source_code_hash = data.archive_file.bootstrap.output_base64sha256

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  dynamic "vpc_config" {
    for_each = length(var.subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_iam_role_policy_attachment.basic_execution
  ]
}
