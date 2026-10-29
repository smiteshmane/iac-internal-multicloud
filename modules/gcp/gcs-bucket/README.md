# Google Cloud Storage (GCS) Bucket Terraform Module

A production-ready, security-hardened, reusable Terraform module for deploying Google Cloud Storage (GCS) buckets with support for Customer-Managed Encryption Keys (CMEK), public access prevention, object versioning, dynamic lifecycle rules, retention policies, access logging, and IAM bindings.

## Features

- **Security Hardened by Default**: Uniform bucket-level access and public access prevention enabled by default (`enforced`).
- **Encryption**: Optional Customer-Managed Encryption Key (CMEK) integration using GCP Cloud KMS.
- **Lifecycle Management**: Dynamic lifecycle rules supporting object expiration, storage class transitions, and version pruning.
- **Data Protection**: Object versioning and optional retention lock policies.
- **Access Logging**: Built-in access logging integration.
- **IAM Management**: Dynamic bucket-level IAM role member bindings with condition support.
- **Validation**: Strict HCL variable validation rules for bucket naming conventions, storage classes, public access prevention modes, and standard labels.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

---

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

---

## Usage Examples

### Standard Secure GCS Bucket

```hcl
module "app_data_bucket" {
  source = "./modules/gcs-bucket"

  bucket_name = "my-company-prod-app-data"
  project_id  = "my-gcp-project-123"
  location    = "US"

  versioning_enabled          = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  labels = {
    environment = "prod"
    managed_by  = "terraform"
    team        = "platform"
  }
}
```

### Secure Enterprise Bucket with CMEK & Lifecycle Rules

```hcl
module "enterprise_storage" {
  source = "./modules/gcs-bucket"

  bucket_name   = "my-company-secure-storage-bucket"
  project_id    = "my-gcp-project-123"
  location      = "us-central1"
  storage_class = "STANDARD"

  cmek_kms_key_name = "projects/my-gcp-project-123/locations/us-central1/keyRings/my-keyring/cryptoKeys/my-key"

  versioning_enabled          = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age = 30
      }
    },
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "COLDLINE"
      }
      condition = {
        age = 90
      }
    },
    {
      action = {
        type = "Delete"
      }
      condition = {
        num_newer_versions = 3
      }
    }
  ]

  iam_members = [
    {
      role   = "roles/storage.objectViewer"
      member = "serviceAccount:my-app-sa@my-gcp-project-123.iam.gserviceaccount.com"
    }
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
    compliance  = "hipaa"
  }
}
```

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the GCS bucket. Must be globally unique. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID in which to create the bucket. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The GCS location (region/multi-region/dual-region). | `string` | `"US"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | GCS storage class (STANDARD, NEARLINE, COLDLINE, ARCHIVE). | `string` | `"STANDARD"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Delete all contained objects when destroying bucket. | `bool` | `false` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Enforce Uniform Bucket-Level Access. | `bool` | `true` | no |
| <a name="input_public_access_prevention"></a> [public\_access\_prevention](#input\_public\_access\_prevention) | Prevent public bucket access ('enforced' or 'inherited'). | `string` | `"enforced"` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable object versioning. | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Key/value label map. Must include 'environment' and 'managed_by'. | `map(string)` | `{ environment = "dev", managed_by = "terraform" }` | no |
| <a name="input_cmek_kms_key_name"></a> [cmek\_kms_key\_name](#input\_cmek\_kms\_key\_name) | KMS Key resource path for CMEK encryption. | `string` | `null` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | Retention policy object configuration. | `object` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of lifecycle transition and deletion rules. | `list` | `[]` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | CORS rules configuration list. | `list` | `[]` | no |
| <a name="input_website_config"></a> [website\_config](#input\_website\_config) | Website hosting configuration block. | `object` | `null` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | Access logging configuration block. | `object` | `null` | no |
| <a name="input_iam_members"></a> [iam\_members](#input\_iam\_members) | List of IAM role assignments for the bucket. | `list` | `[]` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The complete GCS bucket resource object. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The bucket ID identifier. |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the Google Cloud Storage bucket. |
| <a name="output_bucket_self_link"></a> [bucket\_self\_link](#output\_bucket\_self\_link) | The URI of the created bucket resource. |
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | The base URL of the bucket in gs:// format. |
