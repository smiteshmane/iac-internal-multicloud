locals {
  user_labels = merge(
    {
      managed_by = "terraform"
    },
    var.user_labels
  )
}
