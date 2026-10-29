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

module "state" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "demo-tf-state"
}

output "s3_bucket_id" {
  value = module.state.s3_bucket_id
}

output "dynamodb_table_name" {
  value = module.state.dynamodb_table_name
}

output "backend_config" {
  value = module.state.backend_config
}
