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

module "ssm_role" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "ssm-ec2-role"

  trusted_role_services   = ["ec2.amazonaws.com"]
  create_instance_profile = true

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

output "role_arn" {
  value = module.ssm_role.iam_role_arn
}

output "instance_profile_arn" {
  value = module.ssm_role.instance_profile_arn
}
