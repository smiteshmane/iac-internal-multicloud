variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "demo"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
