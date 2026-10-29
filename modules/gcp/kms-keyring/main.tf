resource "google_kms_key_ring" "keyring" {
  name     = var.keyring_name
  project  = var.project_id
  location = var.location
}

resource "google_kms_crypto_key" "keys" {
  for_each = { for key in var.keys : key.name => key }

  name            = each.value.name
  key_ring        = google_kms_key_ring.keyring.id
  purpose         = each.value.purpose
  rotation_period = each.value.rotation_period
  labels          = local.labels
}

resource "google_kms_crypto_key_iam_member" "encrypter_decrypters" {
  for_each = { for item in local.key_members : "${item.key_name}/${item.member}" => item }

  crypto_key_id = google_kms_crypto_key.keys[each.value.key_name].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = each.value.member
}
