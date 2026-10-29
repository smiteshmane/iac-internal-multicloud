output "bucket_name" {
  description = "The name of the Google Cloud Storage bucket."
  value       = google_storage_bucket.bucket.name
}

output "bucket_url" {
  description = "The base URL of the bucket in gs:// format."
  value       = google_storage_bucket.bucket.url
}

output "bucket_self_link" {
  description = "The URI of the created bucket resource."
  value       = google_storage_bucket.bucket.self_link
}

output "bucket_id" {
  description = "The bucket ID identifier."
  value       = google_storage_bucket.bucket.id
}

output "bucket" {
  description = "The complete GCS bucket resource object."
  value       = google_storage_bucket.bucket
}
