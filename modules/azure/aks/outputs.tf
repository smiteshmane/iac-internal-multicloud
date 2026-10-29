output "aks_id" {
  description = "The ID of the AKS Cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "aks_name" {
  description = "The name of the AKS Cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl (sensitive)."
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for Workload Identity."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "principal_id" {
  description = "The Principal ID of the System Assigned Managed Identity."
  value       = azurerm_kubernetes_cluster.this.identity[0].principal_id
}
