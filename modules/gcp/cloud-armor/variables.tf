variable "policy_name" {
  type        = string
  description = "The name of the Cloud Armor security policy."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.policy_name))
    error_message = "The policy_name must start with a letter, contain lowercase letters, numbers, or hyphens, up to 63 characters."
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where the Cloud Armor security policy will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be between 6 and 30 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "description" {
  type        = string
  description = "Textual description of the Cloud Armor WAF policy."
  default     = "Cloud Armor WAF security policy managed by Terraform."
}

variable "enable_owasp_rules" {
  type        = bool
  description = "Whether to enable OWASP Top 10 preconfigured protection rules (SQLi, XSS, RCE, LFI)."
  default     = true
}

variable "blocked_ip_ranges" {
  type        = list(string)
  description = "List of IP ranges to block in Cloud Armor policy."
  default     = []
}

variable "allowed_ip_ranges" {
  type        = list(string)
  description = "List of IP ranges to explicitly allow."
  default     = []
}

variable "rate_limit_count" {
  type        = number
  description = "Maximum request count allowed within threshold interval before rate limiting kicks in."
  default     = 100
}

variable "rate_limit_interval_sec" {
  type        = number
  description = "Threshold interval in seconds for rate limiting evaluation (e.g. 60s)."
  default     = 60
}

variable "enable_rate_limiting" {
  type        = bool
  description = "Whether to enable rate limiting rule."
  default     = false
}
