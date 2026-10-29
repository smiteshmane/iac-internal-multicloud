locals {
  # Standardized resource labels merging default terraform tags with user-provided labels
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  # CMEK encryption status flag
  is_cmek_enabled = var.cmek_kms_key_name != null
}
