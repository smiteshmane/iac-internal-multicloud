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

module "alb" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "demo-alb"

  subnets         = ["subnet-0123456789abcdef0", "subnet-0fe23456789abcdef"]
  security_groups = ["sg-0123456789abcdef0"]

  target_groups = {
    app = {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  }

  http_tcp_listeners = [
    {
      port              = 80
      protocol          = "HTTP"
      redirect_to_https = false
      target_group_key  = "app"
    }
  ]
}

output "lb_dns_name" {
  value = module.alb.lb_dns_name
}
