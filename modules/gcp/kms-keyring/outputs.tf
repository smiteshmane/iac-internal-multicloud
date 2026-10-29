output "keyring_id" {
  description = "The fully qualified resource path of the Cloud KMS KeyRing."
  value       = google_kms_key_ring.keyring.id
}

output "key_ids" {
  description = "Map of created CryptoKeys and their fully qualified resource IDs for CMEK parameters."
  value       = { for k, v in google_kms_crypto_key.keys : k => v.id }
}
