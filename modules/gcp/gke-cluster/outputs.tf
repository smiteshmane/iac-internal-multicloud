output "cluster_name" {
  description = "The name of the created GKE cluster."
  value       = google_container_cluster.primary.name
}

output "cluster_id" {
  description = "The GKE cluster resource ID."
  value       = google_container_cluster.primary.id
}

output "endpoint" {
  description = "The IP address of this cluster's Kubernetes Master."
  value       = google_container_cluster.primary.endpoint
}

output "ca_certificate" {
  description = "The base64 encoded public certificate that is the CA of the cluster."
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "workload_identity_pool" {
  description = "The Workload Identity pool name."
  value       = local.workload_identity_pool
}
