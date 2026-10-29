# API Gateway v2 HTTP API Resource
resource "aws_apigatewayv2_api" "this" {
  count = var.create ? 1 : 0

  name          = local.name_prefix
  description   = var.description
  protocol_type = var.protocol_type

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# CloudWatch Log Group for Access Logs
resource "aws_cloudwatch_log_group" "api_logs" {
  count = var.create ? 1 : 0

  name              = "/aws/apigateway/${local.name_prefix}"
  retention_in_days = 30

  tags = local.merged_tags
}

# API Gateway v2 Stage
resource "aws_apigatewayv2_stage" "this" {
  count = var.create ? 1 : 0

  api_id      = aws_apigatewayv2_api.this[0].id
  name        = var.stage_name
  auto_deploy = var.auto_deploy

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs[0].arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      httpMethod              = "$context.httpMethod"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      protocol                = "$context.protocol"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }

  tags = local.merged_tags
}
