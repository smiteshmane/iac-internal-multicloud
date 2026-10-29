variable "create" {
  description = "Controls whether EC2 instance resources should be created"
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
  description = "Name identifier for the EC2 instance"
  type        = string
  default     = "server"
}

variable "name_prefix" {
  description = "Custom override prefix for EC2 resource naming"
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string

  validation {
    condition     = can(regex("^ami-[a-z0-9]+$", var.ami_id))
    error_message = "ami_id must be a valid AWS AMI ID starting with ami-."
  }
}

variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch instance in"
  type        = string

  validation {
    condition     = can(regex("^subnet-[a-z0-9]+$", var.subnet_id))
    error_message = "subnet_id must be a valid AWS Subnet ID starting with subnet-."
  }
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile name to launch the instance with"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data script to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When set to true, changes in user_data will force a new resource to be created"
  type        = bool
  default     = true
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed CloudWatch monitoring enabled"
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = true
}

variable "root_block_device" {
  description = "Customize details of the root block device of the instance"
  type = object({
    volume_type           = optional(string, "gp3")
    volume_size           = optional(number, 30)
    encrypted             = optional(bool, true)
    kms_key_id            = optional(string, null)
    delete_on_termination = optional(bool, true)
    throughput            = optional(number, 125)
    iops                  = optional(number, 3000)
  })
  default = {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true
  }
}

variable "ebs_block_devices" {
  description = "Additional EBS block devices to attach to the instance"
  type = list(object({
    device_name           = string
    volume_type           = optional(string, "gp3")
    volume_size           = number
    encrypted             = optional(bool, true)
    kms_key_id            = optional(string, null)
    delete_on_termination = optional(bool, true)
  }))
  default = []
}

variable "metadata_options" {
  description = "Customize Metadata Options IMDSv2 settings for enterprise security"
  type = object({
    http_endpoint               = optional(string, "enabled")
    http_tokens                 = optional(string, "required")
    http_put_response_hop_limit = optional(number, 1)
    instance_metadata_tags      = optional(string, "enabled")
  })
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
}

variable "create_spot_instance" {
  description = "Whether to launch as an EC2 Spot Instance Request instead of standard On-Demand instance"
  type        = bool
  default     = false
}

variable "spot_price" {
  description = "The maximum price to request on the spot market"
  type        = string
  default     = null
}

variable "spot_type" {
  description = "Spot request type (one-time or persistent)"
  type        = string
  default     = "one-time"
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
