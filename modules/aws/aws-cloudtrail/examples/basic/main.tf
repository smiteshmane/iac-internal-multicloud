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

module "cloudtrail" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "demo-trail"

  is_multi_region_trail      = true
  enable_log_file_validation = true
  enable_cloudwatch_logs     = true
}

output "trail_arn" {
  value = module.cloudtrail.trail_arn
}

output "s3_bucket_id" {
  value = module.cloudtrail.s3_bucket_id
}
