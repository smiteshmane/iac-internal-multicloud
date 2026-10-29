locals {
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  # Formatted repository URL depending on format and region
  repository_url = "${var.location}-${lower(var.format)}.pkg.dev/${var.project_id}/${var.repository_id}"
}
