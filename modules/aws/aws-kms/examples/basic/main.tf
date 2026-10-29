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

module "kms" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "app-kms-key"

  enable_key_rotation     = true
  deletion_window_in_days = 14

  key_service_principals = [
    "logs.amazonaws.com"
  ]
}

output "key_arn" {
  value = module.kms.key_arn
}

output "alias_name" {
  value = module.kms.alias_name
}
