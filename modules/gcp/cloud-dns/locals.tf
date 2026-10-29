locals {
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  is_private = var.visibility == "private"
}
