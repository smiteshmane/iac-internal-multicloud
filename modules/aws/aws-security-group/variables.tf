variable "create" {
  description = "Controls whether security group resources should be created"
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
  description = "Name identifier for the security group"
  type        = string
  default     = "sg"
}

variable "name_prefix" {
  description = "Custom override for security group name prefix"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Managed Security Group"
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "VPC ID must be a valid AWS VPC ID starting with vpc-."
  }
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all the Security Group's attached ingress and egress rules before deleting the security group itself"
  type        = bool
  default     = false
}

variable "ingress_rules" {
  description = "List of ingress rule objects specifying port range, protocol, description, and target CIDR/SG/Prefix lists"
  type = list(object({
    description              = optional(string, "Ingress rule")
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string), [])
    ipv6_cidr_blocks         = optional(list(string), [])
    prefix_list_ids          = optional(list(string), [])
    source_security_group_id = optional(string, null)
    self                     = optional(bool, false)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rule objects specifying port range, protocol, description, and destination CIDR/SG/Prefix lists"
  type = list(object({
    description                   = optional(string, "Egress rule")
    from_port                     = number
    to_port                       = number
    protocol                      = string
    cidr_blocks                   = optional(list(string), [])
    ipv6_cidr_blocks              = optional(list(string), [])
    prefix_list_ids               = optional(list(string), [])
    destination_security_group_id = optional(string, null)
    self                          = optional(bool, false)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
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
