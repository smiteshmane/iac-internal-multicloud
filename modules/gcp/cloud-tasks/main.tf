resource "google_cloud_tasks_queue" "queue" {
  name     = var.queue_name
  project  = var.project_id
  location = var.location

  rate_limits {
    max_dispatches_per_second = var.max_dispatches_per_second
    max_concurrent_dispatches = var.max_concurrent_dispatches
  }

  retry_config {
    max_attempts  = var.max_attempts
    min_backoff   = "${var.min_backoff_sec}s"
    max_backoff   = "${var.max_backoff_sec}s"
    max_doublings = 16
  }
}

resource "google_cloud_tasks_queue_iam_member" "enqueuers" {
  for_each = toset(var.queue_enqueuers)

  project  = google_cloud_tasks_queue.queue.project
  location = google_cloud_tasks_queue.queue.location
  name     = google_cloud_tasks_queue.queue.name
  role     = "roles/cloudtasks.enqueuer"
  member   = each.value
}
