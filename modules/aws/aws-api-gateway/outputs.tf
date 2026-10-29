output "api_id" {
  description = "ID of the API Gateway v2 API"
  value       = try(aws_apigatewayv2_api.this[0].id, "")
}

output "api_arn" {
  description = "ARN of the API Gateway v2 API"
  value       = try(aws_apigatewayv2_api.this[0].arn, "")
}

output "api_endpoint" {
  description = "Default execution endpoint URL of the API Gateway"
  value       = try(aws_apigatewayv2_api.this[0].api_endpoint, "")
}

output "stage_id" {
  description = "ID of the API Gateway stage"
  value       = try(aws_apigatewayv2_stage.this[0].id, "")
}

output "stage_arn" {
  description = "ARN of the API Gateway stage"
  value       = try(aws_apigatewayv2_stage.this[0].arn, "")
}
