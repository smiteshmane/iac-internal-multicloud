variable "repository_id" {
  type        = string
  description = "The last part of the repository name (e.g. app-docker-repo)."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.repository_id))
    error_message = "The repository_id must start with a letter, contain lowercase letters, numbers, or hyphens, and be up to 63 characters long."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Artifact Registry repository will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "location" {
  type        = string
  description = "The location of the repository (region or multi-region, e.g. us-central1 or us)."
  default     = "us-central1"
}

variable "format" {
  type        = string
  description = "The format of packages stored in the repository. Supported: DOCKER, MAVEN, NPM, PYTHON, HELM."
  default     = "DOCKER"

  validation {
    condition     = contains(["DOCKER", "MAVEN", "NPM", "PYTHON", "HELM"], var.format)
    error_message = "The format must be one of: DOCKER, MAVEN, NPM, PYTHON, HELM."
  }
}

variable "description" {
  type        = string
  description = "User-specified description of the repository."
  default     = "Production Artifact Registry repository managed by Terraform."
}

variable "cmek_kms_key_name" {
  type        = string
  description = "The Cloud KMS key resource path for Customer-Managed Encryption Key (CMEK)."
  default     = null
}

variable "cleanup_policies" {
  type = list(object({
    id     = string
    action = optional(string, "DELETE")
    condition = optional(object({
      tag_state    = optional(string, "ANY")
      tag_prefixes = optional(list(string), [])
      older_than   = optional(string)
    }))
  }))
  description = "Dynamic list of cleanup policies for image retention and tag management."
  default     = []
}

variable "iam_members" {
  type = list(object({
    role   = string
    member = string
  }))
  description = "Dynamic list of IAM role bindings for the repository."
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
