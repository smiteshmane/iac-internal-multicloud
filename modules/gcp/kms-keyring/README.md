# GCP Cloud KMS Keyring & Keys Terraform Module

Production-ready Terraform module for provisioning Google Cloud KMS KeyRings, CryptoKeys, automated 90-day key rotation schedules, and `roles/cloudkms.cryptoKeyEncrypterDecrypter` IAM bindings for Customer-Managed Encryption (CMEK).

## Features
- **KeyRing Lifecycle**: Centralized KMS KeyRing management across global or regional locations.
- **Automated Rotation**: Automatic key rotation schedules (e.g. 90-day rotation period).
- **CMEK IAM Bindings**: Automated Encrypter/Decrypter role assignments for GCS, Cloud SQL, Compute Engine, and BigQuery service accounts.

## Usage Example

```hcl
module "kms" {
  source = "./modules/kms-keyring"

  keyring_name = "prod-cmek-keyring"
  project_id   = "my-gcp-project-123456"
  location     = "us-central1"

  keys = [
    {
      name            = "storage-cmek-key"
      rotation_period = "7776000s" # 90 days
      encrypter_decrypters = [
        "serviceAccount:service-123456@gs-project-accounts.iam.gserviceaccount.com"
      ]
    }
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
