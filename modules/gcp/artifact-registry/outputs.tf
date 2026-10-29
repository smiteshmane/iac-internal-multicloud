output "repository_id" {
  description = "The repository ID."
  value       = google_artifact_registry_repository.repo.repository_id
}

output "name" {
  description = "The fully qualified name of the Artifact Registry repository."
  value       = google_artifact_registry_repository.repo.name
}

output "location" {
  description = "The location of the repository."
  value       = google_artifact_registry_repository.repo.location
}

output "format" {
  description = "The package format of the repository."
  value       = google_artifact_registry_repository.repo.format
}

output "repository_url" {
  description = "The base URL for pushing and pulling packages/docker images."
  value       = local.repository_url
}
