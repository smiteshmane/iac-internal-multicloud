output "topic_name" {
  description = "The name of the created Pub/Sub topic."
  value       = google_pubsub_topic.topic.name
}

output "topic_id" {
  description = "The Pub/Sub topic resource ID."
  value       = google_pubsub_topic.topic.id
}

output "subscriptions" {
  description = "Map of created subscriptions and their IDs."
  value       = { for k, v in google_pubsub_subscription.subscriptions : k => v.id }
}
