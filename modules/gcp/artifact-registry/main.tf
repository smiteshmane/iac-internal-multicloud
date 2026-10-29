resource "google_artifact_registry_repository" "repo" {
  repository_id = var.repository_id
  project       = var.project_id
  location      = var.location
  format        = var.format
  description   = var.description
  kms_key_name  = var.cmek_kms_key_name

  labels = local.labels

  dynamic "cleanup_policies" {
    for_each = var.cleanup_policies
    content {
      id     = cleanup_policies.value.id
      action = cleanup_policies.value.action

      dynamic "condition" {
        for_each = cleanup_policies.value.condition != null ? [cleanup_policies.value.condition] : []
        content {
          tag_state    = condition.value.tag_state
          tag_prefixes = condition.value.tag_prefixes
          older_than   = condition.value.older_than
        }
      }
    }
  }
}

resource "google_artifact_registry_repository_iam_member" "iam_members" {
  for_each = { for idx, item in var.iam_members : "${item.role}-${item.member}" => item }

  project    = google_artifact_registry_repository.repo.project
  location   = google_artifact_registry_repository.repo.location
  repository = google_artifact_registry_repository.repo.name
  role       = each.value.role
  member     = each.value.member
}
