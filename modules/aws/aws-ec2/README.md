# AWS EC2 Terraform Module

Enterprise-ready Terraform module for deploying Amazon EC2 instances enforcing AWS security standards, mandatory IMDSv2 token enforcement, EBS root and secondary volume encryption, CloudWatch monitoring, IAM profile binding, and optional Spot instance integration.

## Features

- **Mandatory IMDSv2 Enforcement**: Configures `metadata_options` with `http_tokens = "required"` to prevent SSRF vulnerabilities and token theft.
- **EBS Encryption by Default**: Root volume and secondary EBS volumes are encrypted using AWS managed or customer-managed KMS keys.
- **Spot Instance Integration**: Easily switch between On-Demand and Spot instances via `create_spot_instance = true`.
- **CloudWatch Detailed Monitoring**: Enables detailed monitoring by default for real-time metrics visibility.

## Usage Example

```hcl
module "app_server" {
  source = "../../modules/aws-ec2"

  project     = "acme"
  environment = "prod"
  name        = "web-server"

  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.medium"
  subnet_id     = "subnet-0123456789abcdef0"

  vpc_security_group_ids = ["sg-0123456789abcdef0"]
  iam_instance_profile   = "acme-prod-ssm-profile"

  root_block_device = {
    volume_type = "gp3"
    volume_size = 50
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World" > /var/www/html/index.html
              EOF
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether to create instance | `bool` | `true` | no |
| `project` | Project identifier | `string` | `"enterprise"` | no |
| `environment` | Environment identifier | `string` | n/a | yes |
| `name` | Instance name | `string` | `"server"` | no |
| `ami_id` | AWS AMI ID | `string` | n/a | yes |
| `instance_type` | Instance type | `string` | `"t3.micro"` | no |
| `subnet_id` | VPC Subnet ID | `string` | n/a | yes |
| `vpc_security_group_ids` | List of Security Group IDs | `list(string)` | `[]` | no |
| `create_spot_instance` | Launch as Spot Instance | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the instance |
| `arn` | The ARN of the instance |
| `private_ip` | Private IP address |
| `public_ip` | Public IP address |
