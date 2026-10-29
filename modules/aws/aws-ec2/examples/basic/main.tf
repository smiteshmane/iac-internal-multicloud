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

module "ec2" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "demo-ec2"

  ami_id                 = "ami-0c55b159cbfafe1f0"
  instance_type          = "t3.micro"
  subnet_id              = "subnet-0123456789abcdef0"
  vpc_security_group_ids = ["sg-0123456789abcdef0"]

  monitoring = true
}

output "instance_id" {
  value = module.ec2.id
}

output "private_ip" {
  value = module.ec2.private_ip
}
