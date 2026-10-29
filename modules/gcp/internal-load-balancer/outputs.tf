output "internal_ip" {
  description = "The reserved private internal IPv4 address of the Internal Load Balancer."
  value       = google_compute_forwarding_rule.forwarding_rule.ip_address
}

output "backend_service_id" {
  description = "The ID of the regional internal backend service."
  value       = google_compute_region_backend_service.backend.id
}

output "forwarding_rule_id" {
  description = "The ID of the internal forwarding rule."
  value       = google_compute_forwarding_rule.forwarding_rule.id
}
