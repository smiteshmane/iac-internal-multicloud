resource "google_pubsub_topic" "topic" {
  name         = var.topic_name
  project      = var.project_id
  kms_key_name = var.cmek_kms_key_name
  labels       = local.labels
}

resource "google_pubsub_subscription" "subscriptions" {
  for_each = { for sub in var.subscriptions : sub.name => sub }

  name    = each.value.name
  project = var.project_id
  topic   = google_pubsub_topic.topic.name
  labels  = local.labels

  ack_deadline_seconds       = each.value.ack_deadline_seconds
  retain_acked_messages      = each.value.retain_acked_messages
  message_retention_duration = each.value.message_retention_duration
  enable_message_ordering    = each.value.enable_message_ordering
  filter                     = each.value.filter

  dynamic "push_config" {
    for_each = each.value.push_endpoint != null ? [each.value.push_endpoint] : []
    content {
      push_endpoint = push_config.value
    }
  }

  dynamic "dead_letter_policy" {
    for_each = each.value.dead_letter_topic != null ? [each.value.dead_letter_topic] : []
    content {
      dead_letter_topic     = dead_letter_policy.value
      max_delivery_attempts = each.value.max_delivery_attempts
    }
  }
}

resource "google_pubsub_topic_iam_member" "publishers" {
  for_each = toset(var.publishers)

  project = google_pubsub_topic.topic.project
  topic   = google_pubsub_topic.topic.name
  role    = "roles/pubsub.publisher"
  member  = each.value
}

resource "google_pubsub_topic_iam_member" "subscribers" {
  for_each = toset(var.subscribers)

  project = google_pubsub_topic.topic.project
  topic   = google_pubsub_topic.topic.name
  role    = "roles/pubsub.subscriber"
  member  = each.value
}
