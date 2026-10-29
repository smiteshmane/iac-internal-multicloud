output "name" {
  description = "The name of the created Eventarc trigger."
  value       = google_eventarc_trigger.trigger.name
}

output "id" {
  description = "The fully qualified resource path of the Eventarc trigger."
  value       = google_eventarc_trigger.trigger.id
}
