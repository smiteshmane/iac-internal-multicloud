variable "create" {
  description = "Controls whether ECS resources should be created"
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
  description = "Name identifier for the ECS Cluster and Service"
  type        = string
  default     = "app"
}

variable "name_prefix" {
  description = "Custom override prefix for resource naming"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "Docker container image to deploy (e.g. public.ecr.aws/nginx/nginx:latest)"
  type        = string
  default     = "public.ecr.aws/nginx/nginx:latest"
}

variable "container_name" {
  description = "Name of the container in the task definition"
  type        = string
  default     = "nginx"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "container_cpu" {
  description = "The number of cpu units used by the task (e.g. 256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "The amount of memory (in MiB) used by the task (e.g. 512)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 2
}

variable "subnet_ids" {
  description = "Subnets associated with the task or service (should be private subnets for security)"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security groups associated with the task or service"
  type        = list(string)
  default     = []
}

variable "target_group_arn" {
  description = "ARN of the Load Balancer Target Group to associate with the service"
  type        = string
  default     = null
}

variable "execution_role_arn" {
  description = "ARN of the task execution role that authorizes ECS to pull images and push logs"
  type        = string
  default     = null
}

variable "task_role_arn" {
  description = "ARN of the IAM role that allows container tasks to make calls to AWS services"
  type        = string
  default     = null
}

variable "assign_public_ip" {
  description = "Assign a public IP address to the ENI (Should be false for private subnets)"
  type        = bool
  default     = false
}

variable "capacity_providers" {
  description = "Capacity providers to associate with the cluster"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "log_retention_in_days" {
  description = "Retention period for CloudWatch Log Group in days"
  type        = number
  default     = 30
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
