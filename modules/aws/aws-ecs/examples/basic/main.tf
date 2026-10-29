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

module "ecs" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "demo-ecs"

  container_image = "public.ecr.aws/nginx/nginx:latest"
  container_port  = 80
  desired_count   = 1

  subnet_ids         = ["subnet-0123456789abcdef0"]
  security_group_ids = ["sg-0123456789abcdef0"]
}

output "cluster_name" {
  value = module.ecs.cluster_name
}
