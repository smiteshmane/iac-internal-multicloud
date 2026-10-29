output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = try(aws_eks_cluster.this[0].name, "")
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = try(aws_eks_cluster.this[0].arn, "")
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API server"
  value       = try(aws_eks_cluster.this[0].endpoint, "")
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with your cluster"
  value       = try(aws_eks_cluster.this[0].certificate_authority[0].data, "")
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = try(aws_eks_node_group.this[0].arn, "")
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = try(aws_eks_node_group.this[0].status, "")
}
