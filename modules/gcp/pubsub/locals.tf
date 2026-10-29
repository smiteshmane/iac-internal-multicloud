locals {
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )
}
