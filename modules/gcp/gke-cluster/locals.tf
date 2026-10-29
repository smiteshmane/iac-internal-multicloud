locals {
  # Merged default labels
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  workload_identity_pool = "${var.project_id}.svc.id.goog"
}
