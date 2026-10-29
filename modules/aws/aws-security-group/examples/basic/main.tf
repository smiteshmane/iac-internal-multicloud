terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "app_sg" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "app-server-sg"
  vpc_id      = "vpc-0123456789abcdef0"
  description = "Security group for application tier instances"

  ingress_rules = [
    {
      description = "HTTPS from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "Allow inter-node application traffic"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      self        = true
    }
  ]

  egress_rules = [
    {
      description = "Allow outbound to internet"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

output "security_group_id" {
  value = module.app_sg.security_group_id
}
