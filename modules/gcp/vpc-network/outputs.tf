output "network_name" {
  description = "The name of the created VPC network."
  value       = google_compute_network.vpc.name
}

output "network_id" {
  description = "The VPC network resource ID."
  value       = google_compute_network.vpc.id
}

output "network_self_link" {
  description = "The URI self_link of the VPC network."
  value       = google_compute_network.vpc.self_link
}

output "subnets" {
  description = "Map of created subnets keyed by region/name."
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.self_link }
}

output "router_name" {
  description = "Name of Cloud Router if NAT is enabled."
  value       = var.enable_cloud_nat ? google_compute_router.router[0].name : null
}
