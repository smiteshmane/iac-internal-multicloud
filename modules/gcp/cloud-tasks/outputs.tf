output "queue_name" {
  description = "The name of the Cloud Tasks queue."
  value       = google_cloud_tasks_queue.queue.name
}

output "id" {
  description = "The fully qualified resource path of the queue."
  value       = google_cloud_tasks_queue.queue.id
}
