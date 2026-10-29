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

module "s3_bucket" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "app-assets"

  versioning_status = "Enabled"
  sse_algorithm     = "AES256"
  enforce_tls       = true
}

output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

output "bucket_id" {
  value = module.s3_bucket.bucket_id
}
