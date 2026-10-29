resource "google_service_account" "sa" {
  account_id   = var.account_id
  project      = var.project_id
  display_name = var.display_name
  description  = var.description
}

resource "google_project_iam_member" "roles" {
  for_each = toset(var.project_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_service_account_iam_member" "workload_identity" {
  for_each = toset(var.workload_identity_users)

  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = each.value
}
