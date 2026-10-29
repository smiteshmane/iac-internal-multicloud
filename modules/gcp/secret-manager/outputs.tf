output "secret_id" {
  description = "The secret ID."
  value       = google_secret_manager_secret.secret.secret_id
}

output "id" {
  description = "The fully qualified resource path of the secret."
  value       = google_secret_manager_secret.secret.id
}

output "name" {
  description = "The resource name of the secret."
  value       = google_secret_manager_secret.secret.name
}

output "secret_version_id" {
  description = "The version ID of the populated initial secret version (if secret_data was provided)."
  value       = length(google_secret_manager_secret_version.version) > 0 ? google_secret_manager_secret_version.version[0].version : null
}
