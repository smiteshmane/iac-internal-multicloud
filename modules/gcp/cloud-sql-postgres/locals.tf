locals {
  # Merged default labels
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )
}
