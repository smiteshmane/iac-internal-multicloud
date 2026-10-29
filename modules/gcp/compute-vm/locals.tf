locals {
  # Merge standard labels with user-defined labels
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  # Merge metadata maps including OS Login setting
  metadata = merge(
    var.metadata,
    {
      enable-oslogin = var.enable_oslogin ? "TRUE" : "FALSE"
    },
    var.startup_script != null ? { startup-script = var.startup_script } : {}
  )

  is_cmek_enabled = var.cmek_kms_key_name != null
}
