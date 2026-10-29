output "name" {
  description = "The name of the created Cloud Scheduler job."
  value       = google_cloud_scheduler_job.job.name
}

output "id" {
  description = "The fully qualified resource path of the Cloud Scheduler job."
  value       = google_cloud_scheduler_job.job.id
}
