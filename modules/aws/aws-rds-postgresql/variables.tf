variable "create" {
  description = "Controls whether RDS PostgreSQL resources should be created"
  type        = bool
  default     = true
}

variable "project" {
  description = "Project name to be used for tag and resource naming conventions"
  type        = string
  default     = "enterprise"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment (e.g. dev, qa, uat, prod, sandbox, staging)"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "uat", "prod", "sandbox", "staging"], var.environment)
    error_message = "Environment must be one of: dev, qa, uat, prod, sandbox, staging."
  }
}

variable "name" {
  description = "Name identifier for the PostgreSQL database"
  type        = string
  default     = "postgres-db"
}

variable "name_prefix" {
  description = "Custom override prefix for database resource naming"
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "PostgreSQL engine version (e.g. 14.9, 15.4, 16.1)"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "The instance type of the RDS PostgreSQL instance"
  type        = string
  default     = "db.t4g.medium"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Upper limit to which RDS can automatically scale storage"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type: gp2, gp3, io1"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
  default     = null
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
}

variable "password" {
  description = "Password for the master DB user. If null, a secure random password is generated"
  type        = string
  default     = null
  sensitive   = true
}

variable "port" {
  description = "The port on which the PostgreSQL DB accepts connections"
  type        = number
  default     = 5432
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs for DB subnet group creation"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "parameter_group_family" {
  description = "The family of the DB parameter group (e.g. postgres14, postgres15, postgres16)"
  type        = string
  default     = "postgres15"
}

variable "parameters" {
  description = "Additional DB parameters to apply to PostgreSQL"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  default = []
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before deletion"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "monitoring_interval" {
  description = "The interval in seconds for Enhanced Monitoring metrics"
  type        = number
  default     = 60
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional specific tags to merge with common tags"
  type        = map(string)
  default     = {}
}
