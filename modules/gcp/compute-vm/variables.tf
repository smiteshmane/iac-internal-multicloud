variable "instance_name" {
  type        = string
  description = "The name of the Compute Engine VM instance."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.instance_name))
    error_message = "The instance_name must start with a letter, contain only lowercase letters, numbers, or hyphens, and be up to 63 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the VM instance will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "zone" {
  type        = string
  description = "The GCP zone where the VM instance will be deployed."
  default     = "us-central1-a"
}

variable "machine_type" {
  type        = string
  description = "The machine type for the VM instance (e.g. e2-micro, e2-medium, n2-standard-2)."
  default     = "e2-micro"
}

variable "subnetwork" {
  type        = string
  description = "The self_link or name of the VPC subnetwork to attach the VM interface."
}

variable "enable_public_ip" {
  type        = bool
  description = "Whether to assign an ephemeral public IP address to the VM."
  default     = false
}

variable "static_internal_ip" {
  type        = string
  description = "Optional static internal IP address to assign to the primary network interface."
  default     = null
}

variable "boot_disk_image" {
  type        = string
  description = "The image name or family from which to initialize the boot disk."
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size_gb" {
  type        = number
  description = "Size of the boot disk in GB."
  default     = 20
}

variable "boot_disk_type" {
  type        = string
  description = "The GCE disk type for the boot disk (e.g., pd-standard, pd-ssd, pd-balanced)."
  default     = "pd-standard"

  validation {
    condition     = contains(["pd-standard", "pd-ssd", "pd-balanced", "hyperdisk-balanced"], var.boot_disk_type)
    error_message = "The boot_disk_type must be one of: pd-standard, pd-ssd, pd-balanced, hyperdisk-balanced."
  }
}

variable "boot_disk_auto_delete" {
  type        = bool
  description = "Whether to auto-delete the boot disk when the instance is deleted."
  default     = true
}

variable "attached_disks" {
  type = list(object({
    source      = string
    device_name = optional(string)
    mode        = optional(string, "READ_WRITE")
  }))
  description = "Dynamic list of secondary persistent disks to attach to the VM."
  default     = []
}

variable "cmek_kms_key_name" {
  type        = string
  description = "Cloud KMS Key resource path for Customer-Managed Encryption (CMEK) on boot disk."
  default     = null
}

variable "service_account_email" {
  type        = string
  description = "The Service Account email attached to the VM. If null, default Compute engine service account is used."
  default     = null
}

variable "service_account_scopes" {
  type        = list(string)
  description = "List of service account OAuth scopes."
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "enable_shielded_vm" {
  type        = bool
  description = "Enable Shielded VM features (Secure Boot, vTPM, Integrity Monitoring)."
  default     = true
}

variable "enable_oslogin" {
  type        = bool
  description = "Enable GCP OS Login for SSH user access control."
  default     = true
}

variable "startup_script" {
  type        = string
  description = "Optional bash startup script metadata script executed on VM boot."
  default     = null
}

variable "metadata" {
  type        = map(string)
  description = "Map of custom metadata key/value pairs."
  default     = {}
}

variable "tags" {
  type        = list(string)
  description = "List of network tags applied to the instance for firewall targeting."
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

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection on the VM instance to prevent accidental destruction."
  default     = false
}
