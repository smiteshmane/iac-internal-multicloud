resource "google_eventarc_trigger" "trigger" {
  name            = var.name
  project         = var.project_id
  location        = var.location
  service_account = var.service_account_email
  labels          = local.labels

  dynamic "matching_criteria" {
    for_each = var.matching_criteria
    content {
      attribute = matching_criteria.value.attribute
      value     = matching_criteria.value.value
    }
  }

  destination {
    cloud_run_service {
      service = var.cloud_run_service
      region  = var.location
      path    = var.cloud_run_path
    }
  }
}
