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

module "rds" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "demo-db"

  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t4g.micro"

  allocated_storage = 20
  multi_az          = false

  db_name  = "demodb"
  username = "demouser"

  subnet_ids             = ["subnet-0123456789abcdef0", "subnet-0fe23456789abcdef"]
  vpc_security_group_ids = ["sg-0123456789abcdef0"]

  deletion_protection = false
  skip_final_snapshot = true
}

output "db_endpoint" {
  value = module.rds.db_instance_endpoint
}
