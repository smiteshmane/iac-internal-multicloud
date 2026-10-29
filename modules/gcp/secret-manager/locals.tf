locals {
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  is_user_managed_replication = length(var.replication_locations) > 0
}
