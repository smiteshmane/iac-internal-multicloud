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

module "cloudwatch" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "demo-monitoring"

  retention_in_days = 30

  metric_alarms = {
    high_cpu = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 1
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 300
      statistic           = "Average"
      threshold           = 90
    }
  }
}

output "log_group_name" {
  value = module.cloudwatch.log_group_name
}
