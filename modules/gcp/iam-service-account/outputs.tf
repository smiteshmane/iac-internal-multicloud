output "email" {
  description = "The email address of the created Service Account."
  value       = google_service_account.sa.email
}

output "account_id" {
  description = "The account ID of the Service Account."
  value       = google_service_account.sa.account_id
}

output "id" {
  description = "The fully qualified resource path of the Service Account."
  value       = google_service_account.sa.id
}

output "name" {
  description = "The resource name of the Service Account."
  value       = google_service_account.sa.name
}
