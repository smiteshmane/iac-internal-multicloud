output "service_name" {
  description = "The name of the created Cloud Run service."
  value       = google_cloud_run_v2_service.service.name
}

output "uri" {
  description = "The main HTTPS URL at which the Cloud Run service is serving traffic."
  value       = google_cloud_run_v2_service.service.uri
}

output "location" {
  description = "The GCP region where the service is located."
  value       = google_cloud_run_v2_service.service.location
}

output "latest_ready_revision" {
  description = "The latest revision name created for the service that is serving traffic."
  value       = google_cloud_run_v2_service.service.latest_ready_revision
}
