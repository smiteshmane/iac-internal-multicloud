output "dataset_id" {
  description = "The dataset ID."
  value       = google_bigquery_dataset.dataset.dataset_id
}

output "dataset_name" {
  description = "The fully qualified resource path of the dataset."
  value       = google_bigquery_dataset.dataset.id
}

output "table_ids" {
  description = "Map of created BigQuery table IDs."
  value       = { for k, v in google_bigquery_table.tables : k => v.table_id }
}
