variable "instance_name" {
  type        = string
  description = "The name of the Cloud SQL PostgreSQL instance."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,97}[a-z0-9]$", var.instance_name))
    error_message = "The instance_name must start with a letter, contain only lowercase letters, numbers, or hyphens, and be between 3 and 98 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Cloud SQL instance will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "region" {
  type        = string
  description = "The GCP region for the Cloud SQL instance."
  default     = "us-central1"
}

variable "database_version" {
  type        = string
  description = "The PostgreSQL database version (e.g. POSTGRES_14, POSTGRES_15)."
  default     = "POSTGRES_15"

  validation {
    condition     = can(regex("^POSTGRES_", var.database_version))
    error_message = "The database_version must start with POSTGRES_."
  }
}

variable "tier" {
  type        = string
  description = "The machine tier/size for the Cloud SQL instance (e.g., db-custom-2-7680, db-f1-micro)."
  default     = "db-custom-2-7680"
}

variable "availability_type" {
  type        = string
  description = "Availability type for HA. Allowed values: 'REGIONAL' (HA) or 'ZONAL'."
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "ZONAL"], var.availability_type)
    error_message = "The availability_type must be either 'REGIONAL' or 'ZONAL'."
  }
}

variable "disk_size_gb" {
  type        = number
  description = "Allocated storage disk size in GB."
  default     = 20
}

variable "disk_type" {
  type        = string
  description = "The type of storage disk (PD_SSD or PD_HDD)."
  default     = "PD_SSD"

  validation {
    condition     = contains(["PD_SSD", "PD_HDD"], var.disk_type)
    error_message = "The disk_type must be either 'PD_SSD' or 'PD_HDD'."
  }
}

variable "disk_autoresize" {
  type        = bool
  description = "Enable automatic storage expansion."
  default     = true
}

variable "private_network" {
  type        = string
  description = "The VPC network self_link for Private Service Access private IP deployment."
  default     = null
}

variable "enable_public_ip" {
  type        = bool
  description = "Whether to assign a public IPv4 address to the database instance."
  default     = false
}

variable "backup_start_time" {
  type        = string
  description = "HH:MM format start time for daily automated backups (UTC)."
  default     = "03:00"
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable Write-Ahead Log (WAL) point-in-time recovery."
  default     = true
}

variable "database_flags" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of PostgreSQL database flags."
  default     = []
}

variable "cmek_kms_key_name" {
  type        = string
  description = "Resource path of Cloud KMS Key for CMEK disk encryption."
  default     = null
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

variable "db_name" {
  type        = string
  description = "Default database name to create."
  default     = "app_db"
}

variable "db_user_name" {
  type        = string
  description = "Default database user name to create."
  default     = "app_user"
}

variable "db_password" {
  type        = string
  description = "Password for default database user."
  sensitive   = true
}
