output "router_name" {
  description = "The name of the Cloud Router."
  value       = google_compute_router.router.name
}

output "nat_name" {
  description = "The name of the Cloud NAT Gateway."
  value       = google_compute_router_nat.nat.name
}

output "nat_ips" {
  description = "List of reserved static IP addresses assigned to Cloud NAT (if num_static_ips > 0)."
  value       = google_compute_address.nat_ips[*].address
}
