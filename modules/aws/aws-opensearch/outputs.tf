output "domain_id" {
  description = "Unique identifier for the OpenSearch domain"
  value       = try(aws_opensearch_domain.this[0].domain_id, "")
}

output "domain_arn" {
  description = "ARN of the OpenSearch domain"
  value       = try(aws_opensearch_domain.this[0].arn, "")
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index and search requests"
  value       = try(aws_opensearch_domain.this[0].endpoint, "")
}

output "dashboard_endpoint" {
  description = "Domain-specific endpoint for OpenSearch Dashboards"
  value       = try(aws_opensearch_domain.this[0].dashboard_endpoint, "")
}
