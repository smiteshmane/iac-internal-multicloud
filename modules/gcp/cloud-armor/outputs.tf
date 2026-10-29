output "policy_id" {
  description = "The fully qualified resource path of the Cloud Armor security policy."
  value       = google_compute_security_policy.policy.id
}

output "policy_name" {
  description = "The name of the Cloud Armor security policy."
  value       = google_compute_security_policy.policy.name
}
