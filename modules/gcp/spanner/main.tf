resource "google_spanner_instance" "spanner" {
  name             = var.instance_name
  project          = var.project_id
  config           = var.config
  display_name     = var.display_name
  processing_units = var.processing_units
  labels           = local.labels
}

resource "google_spanner_database" "databases" {
  for_each = { for db in var.databases : db.name => db }

  instance            = google_spanner_instance.spanner.name
  project             = var.project_id
  name                = each.value.name
  ddl                 = each.value.ddl
  deletion_protection = false
}

resource "google_spanner_database_iam_member" "users" {
  for_each = { for item in local.db_users : "${item.db_name}/${item.member}" => item }

  instance = google_spanner_instance.spanner.name
  project  = var.project_id
  database = google_spanner_database.databases[each.value.db_name].name
  role     = "roles/spanner.databaseUser"
  member   = each.value.member
}
