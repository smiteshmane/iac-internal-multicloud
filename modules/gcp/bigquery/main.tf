resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.dataset_id
  project                    = var.project_id
  location                   = var.location
  description                = var.description
  delete_contents_on_destroy = var.delete_contents_on_destroy
  labels                     = local.labels

  dynamic "default_encryption_configuration" {
    for_each = var.cmek_kms_key_name != null ? [var.cmek_kms_key_name] : []
    content {
      kms_key_name = default_encryption_configuration.value
    }
  }
}

resource "google_bigquery_table" "tables" {
  for_each = { for tbl in var.tables : tbl.table_id => tbl }

  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  project             = var.project_id
  table_id            = each.value.table_id
  schema              = each.value.schema
  clustering          = length(each.value.clustering) > 0 ? each.value.clustering : null
  expiration_time     = each.value.expiration_time
  deletion_protection = false
  labels              = local.labels

  dynamic "time_partitioning" {
    for_each = each.value.time_partitioning_field != null ? [each.value.time_partitioning_field] : []
    content {
      type  = "DAY"
      field = time_partitioning.value
    }
  }

  dynamic "encryption_configuration" {
    for_each = var.cmek_kms_key_name != null ? [var.cmek_kms_key_name] : []
    content {
      kms_key_name = encryption_configuration.value
    }
  }
}
