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

module "vpc" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "main-vpc"

  vpc_cidr = "10.20.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]

  public_subnets   = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnets  = ["10.20.11.0/24", "10.20.12.0/24"]
  database_subnets = ["10.20.21.0/24", "10.20.22.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_flow_log    = true
  enable_s3_endpoint = true

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
