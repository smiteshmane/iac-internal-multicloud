variable "bucket_name" {
  type        = string
  description = "The name of the GCS bucket. Must be globally unique and conform to GCP naming conventions."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "The bucket_name must contain only lowercase letters, numbers, hyphens, underscores, or dots, start and end with an alphanumeric character, and be between 3 and 63 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID in which to create the bucket."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "location" {
  type        = string
  description = "The GCS location (region, multi-region, or dual-region) where bucket data will reside."
  default     = "US"
}

variable "storage_class" {
  type        = string
  description = "The Storage Class of the new bucket. Supported values: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "MULTI_REGIONAL", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "The storage_class must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "force_destroy" {
  type        = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects first."
  default     = false
}

variable "uniform_bucket_level_access" {
  type        = bool
  description = "Enforces Uniform Bucket-Level Access to prevent object-level ACL misconfigurations."
  default     = true
}

variable "public_access_prevention" {
  type        = string
  description = "Prevents public access to the bucket. Allowed values: 'enforced' or 'inherited'."
  default     = "enforced"

  validation {
    condition     = contains(["enforced", "inherited"], var.public_access_prevention)
    error_message = "The public_access_prevention value must be either 'enforced' or 'inherited'."
  }
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable object versioning to retain historical versions of objects."
  default     = true
}

variable "labels" {
  type        = map(string)
  description = "A map of key/value pairs to assign as labels to the bucket. Must include 'environment' and 'managed_by' keys."
  default = {
    environment = "development"
    managed_by  = "terraform"
  }

  validation {
    condition     = contains(keys(var.labels), "environment") && contains(keys(var.labels), "managed_by")
    error_message = "The labels map must include both 'environment' and 'managed_by' keys."
  }
}

variable "cmek_kms_key_name" {
  type        = string
  description = "Resource path of the Cloud KMS key used to encrypt bucket objects (CMEK). If null, Google-managed keys are used."
  default     = null
}

variable "retention_policy" {
  type = object({
    retention_period = number
    is_locked        = optional(bool, false)
  })
  description = "Configuration block for bucket retention policy (in seconds). Is_locked cannot be set to false once enabled and locked."
  default     = null
}

variable "lifecycle_rules" {
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                        = optional(number)
      created_before             = optional(string)
      with_state                 = optional(string)
      matches_storage_class      = optional(list(string))
      matches_prefix             = optional(list(string))
      matches_suffix             = optional(list(string))
      num_newer_versions         = optional(number)
      custom_time_before         = optional(string)
      days_since_custom_time     = optional(number)
      days_since_noncurrent_time = optional(number)
      noncurrent_time_before     = optional(string)
    })
  }))
  description = "List of lifecycle rules to automatically manage object transitions or deletions."
  default     = []
}

variable "cors_rules" {
  type = list(object({
    origin          = optional(list(string))
    method          = optional(list(string))
    response_header = optional(list(string))
    max_age_seconds = optional(number)
  }))
  description = "List of CORS rules for the bucket."
  default     = []
}

variable "website_config" {
  type = object({
    main_page_suffix = optional(string)
    not_found_page   = optional(string)
  })
  description = "Configuration block for website hosting on GCS bucket."
  default     = null
}

variable "logging_config" {
  type = object({
    log_bucket        = string
    log_object_prefix = optional(string)
  })
  description = "Configuration block for bucket access logging."
  default     = null
}

variable "iam_members" {
  type = list(object({
    role   = string
    member = string
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  description = "List of IAM role assignments for the bucket."
  default     = []
}
