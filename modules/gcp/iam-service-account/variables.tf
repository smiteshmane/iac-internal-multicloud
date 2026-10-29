variable "account_id" {
  type        = string
  description = "The service account ID name (e.g. app-workload-sa)."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.account_id))
    error_message = "The account_id must be between 6 and 30 characters, start with a letter, and contain lowercase letters, numbers, or hyphens."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Service Account will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "display_name" {
  type        = string
  description = "Human-readable display name for the Service Account."
  default     = "Managed Service Account created by Terraform."
}

variable "description" {
  type        = string
  description = "Textual description of the Service Account."
  default     = "Managed Service Account created by Terraform."
}

variable "project_roles" {
  type        = list(string)
  description = "List of project-level IAM roles to grant to the Service Account (e.g. roles/storage.objectViewer)."
  default     = []
}

variable "workload_identity_users" {
  type        = list(string)
  description = "List of Workload Identity principal members (e.g. serviceAccount:my-project.svc.id.goog[default/my-ksa])."
  default     = []
}
