output "external_ip" {
  description = "The reserved external global IPv4 address of the Load Balancer."
  value       = google_compute_global_address.ip.address
}

output "url_map_id" {
  description = "The ID of the URL map resource."
  value       = google_compute_url_map.url_map.id
}

output "backend_service_id" {
  description = "The ID of the backend service."
  value       = google_compute_backend_service.backend.id
}

output "security_policy_id" {
  description = "The ID of the Cloud Armor WAF security policy (if enabled)."
  value       = var.enable_cloud_armor ? google_compute_security_policy.cloud_armor[0].id : null
}
