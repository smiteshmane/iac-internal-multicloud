output "instance_id" {
  description = "The name of the Cloud Spanner instance."
  value       = google_spanner_instance.spanner.name
}

output "state" {
  description = "The state of the Spanner instance."
  value       = google_spanner_instance.spanner.state
}

output "database_ids" {
  description = "Map of created Cloud Spanner databases and their IDs."
  value       = { for k, v in google_spanner_database.databases : k => v.id }
}
