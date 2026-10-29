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

module "ecr" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "demo-ecr"

  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true
}

output "repository_url" {
  value = module.ecr.repository_url
}
