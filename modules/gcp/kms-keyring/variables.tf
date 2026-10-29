variable "keyring_name" {
  type        = string
  description = "The name of the Cloud KMS KeyRing."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,63}$", var.keyring_name))
    error_message = "The keyring_name must contain alphanumeric characters, hyphens, or underscores, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the KMS KeyRing will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "location" {
  type        = string
  description = "The location of the KeyRing (e.g. global, us-central1, us)."
  default     = "us-central1"
}

variable "keys" {
  type = list(object({
    name                 = string
    purpose              = optional(string, "ENCRYPT_DECRYPT")
    rotation_period      = optional(string, "7776000s") # Default 90 days rotation
    encrypter_decrypters = optional(list(string), [])
  }))
  description = "Dynamic list of CryptoKeys to manage inside the KeyRing."
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Map of resource labels. Must include 'environment' and 'managed_by'."
  default = {
    environment = "development"
    managed_by  = "terraform"
  }

  validation {
    condition     = contains(keys(var.labels), "environment") && contains(keys(var.labels), "managed_by")
    error_message = "The labels map must include both 'environment' and 'managed_by' keys."
  }
}
