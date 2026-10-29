resource "google_secret_manager_secret" "secret" {
  secret_id = var.secret_id
  project   = var.project_id
  labels    = local.labels

  expire_time = var.expire_time

  replication {
    dynamic "auto" {
      for_each = local.is_user_managed_replication ? [] : [1]
      content {
        dynamic "customer_managed_encryption" {
          for_each = var.cmek_kms_key_name != null ? [var.cmek_kms_key_name] : []
          content {
            kms_key_name = customer_managed_encryption.value
          }
        }
      }
    }

    dynamic "user_managed" {
      for_each = local.is_user_managed_replication ? [1] : []
      content {
        dynamic "replicas" {
          for_each = var.replication_locations
          content {
            location = replicas.value

            dynamic "customer_managed_encryption" {
              for_each = var.cmek_kms_key_name != null ? [var.cmek_kms_key_name] : []
              content {
                kms_key_name = customer_managed_encryption.value
              }
            }
          }
        }
      }
    }
  }

  dynamic "rotation" {
    for_each = var.rotation_period != null ? [var.rotation_period] : []
    content {
      rotation_period = rotation.value
    }
  }
}

resource "google_secret_manager_secret_version" "version" {
  count       = var.secret_data != null ? 1 : 0
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.secret_data
}

resource "google_secret_manager_secret_iam_member" "accessors" {
  for_each  = toset(var.secret_accessors)
  project   = google_secret_manager_secret.secret.project
  secret_id = google_secret_manager_secret.secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value
}
