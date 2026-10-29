output "subnet_name" {
  description = "The name of the created subnetwork."
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_id" {
  description = "The fully qualified resource ID of the subnetwork."
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_self_link" {
  description = "The URI self_link of the subnetwork."
  value       = google_compute_subnetwork.subnet.self_link
}

output "ip_cidr_range" {
  description = "The primary CIDR range of the subnetwork."
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}

output "secondary_ip_ranges" {
  description = "List of secondary IP ranges configured on the subnetwork."
  value       = google_compute_subnetwork.subnet.secondary_ip_range
}
