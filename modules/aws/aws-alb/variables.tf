variable "create" {
  description = "Controls whether ALB resources should be created"
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
  description = "Name identifier for the Application Load Balancer"
  type        = string
  default     = "alb"
}

variable "name_prefix" {
  description = "Custom override prefix for ALB naming"
  type        = string
  default     = ""
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Options: application, network"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the LB"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB"
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = false
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer"
  type        = bool
  default     = true
}

variable "access_logs" {
  description = "Map containing access logging configuration"
  type = object({
    enabled = optional(bool, false)
    bucket  = optional(string, null)
    prefix  = optional(string, null)
  })
  default = {
    enabled = false
  }
}

variable "target_groups" {
  description = "Map of target group definitions"
  type = map(object({
    name_prefix          = optional(string, null)
    backend_protocol     = string
    backend_port         = number
    target_type          = optional(string, "instance")
    deregistration_delay = optional(number, 30)
    health_check = optional(object({
      enabled             = optional(bool, true)
      path                = optional(string, "/")
      port                = optional(string, "traffic-port")
      protocol            = optional(string, "HTTP")
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
      timeout             = optional(number, 5)
      interval            = optional(number, 30)
      matcher             = optional(string, "200-399")
    }), {})
  }))
  default = {}
}

variable "https_listeners" {
  description = "List of HTTPS listener maps"
  type = list(object({
    port             = number
    certificate_arn  = string
    ssl_policy       = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")
    target_group_key = string
  }))
  default = []
}

variable "http_tcp_listeners" {
  description = "List of HTTP listener maps"
  type = list(object({
    port              = number
    protocol          = optional(string, "HTTP")
    redirect_to_https = optional(bool, true)
    target_group_key  = optional(string, null)
  }))
  default = [
    {
      port              = 80
      protocol          = "HTTP"
      redirect_to_https = true
    }
  ]
}

variable "waf_web_acl_arn" {
  description = "The ARN of the WAFv2 Web ACL to associate with the ALB"
  type        = string
  default     = null
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
