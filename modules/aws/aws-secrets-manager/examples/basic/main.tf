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

module "secret" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "api-key-secret"

  secret_key_value = {
    api_key = "sample-secret-api-key-value"
  }
}

output "secret_arn" {
  value = module.secret.secret_arn
}
