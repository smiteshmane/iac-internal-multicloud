variable "create" {
  description = "Controls whether MSK resources should be created"
  type        = bool
  default     = true
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "enterprise"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "dev2", "qa", "uat", "prod", "sandbox", "staging"], var.environment)
    error_message = "Environment must be one of: dev, dev2, qa, uat, prod, sandbox, staging."
  }
}

variable "name" {
  description = "Name identifier for the MSK Cluster"
  type        = string
  default     = "kafka"
}

variable "name_prefix" {
  description = "Custom override for name prefix"
  type        = string
  default     = ""
}

variable "kafka_version" {
  description = "Desired Kafka software version"
  type        = string
  default     = "3.6.0"
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the MSK cluster"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "Specify the instance type to use for the kafka brokers (e.g. kafka.m5.large, kafka.t3.small)"
  type        = string
  default     = "kafka.t3.small"
}

variable "ebs_volume_size" {
  description = "Size in GiB of the EBS volume for the data drive on each broker node"
  type        = number
  default     = 100
}

variable "client_subnets" {
  description = "A list of subnets to connect to in client VPC"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of the security groups to associate with the elastic network interfaces"
  type        = list(string)
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
