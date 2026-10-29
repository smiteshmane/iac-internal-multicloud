# AWS Security Group Terraform Module

Enterprise Terraform module for provisioning standalone Security Groups with decoupled ingress and egress rules, supporting IPv4/IPv6 CIDRs, Prefix Lists, cross-SG references, and self-referencing rules.

## Features

- **Modern Rule Resources**: Uses `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule` to prevent rule drift and inline resource conflicts.
- **Flexible Targets**: Support for IPv4 CIDR blocks, IPv6 CIDR blocks, AWS Managed Prefix Lists, and Source Security Groups.
- **Self Referencing Rules**: Easy toggle to allow traffic between resources assigned to the same Security Group.
- **Validation**: Strict VPC ID format checking and standardized environment tags.

## Usage Example

```hcl
module "web_sg" {
  source = "../../modules/aws-security-group"

  project     = "acme"
  environment = "prod"
  name        = "web-alb-sg"
  vpc_id      = "vpc-0123456789abcdef0"
  description = "Security group for web application load balancer"

  ingress_rules = [
    {
      description = "HTTPS inbound"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP inbound"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether to create resources | `bool` | `true` | no |
| `project` | Project name | `string` | `"enterprise"` | no |
| `environment` | Deployment environment | `string` | n/a | yes |
| `name` | Security Group name identifier | `string` | `"sg"` | no |
| `vpc_id` | AWS VPC ID | `string` | n/a | yes |
| `ingress_rules` | List of ingress rules | `list(object)` | `[]` | no |
| `egress_rules` | List of egress rules | `list(object)` | `[...]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `security_group_id` | The ID of the security group |
| `security_group_arn` | The ARN of the security group |
| `ingress_rule_ids` | List of IDs of created ingress rules |
| `egress_rule_ids` | List of IDs of created egress rules |
