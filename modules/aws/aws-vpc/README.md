# AWS VPC Terraform Module

Enterprise-grade Terraform module to create AWS Virtual Private Cloud (VPC) infrastructure following AWS Well-Architected guidelines, zero-trust network segregation, and enterprise naming conventions.

## Architecture Overview

This module provisions a highly customizable VPC environment including:
- Multi-AZ Public, Private, and Database subnet tiers
- Internet Gateway (IGW) for public subnets
- Managed NAT Gateways (Single, Per-AZ, or Per-Subnet)
- Decoupled Route Tables for each subnet tier
- VPC Flow Logs with CloudWatch Logs or S3 destination
- Gateway VPC Endpoints for S3 and DynamoDB

## Features

- **Multi-Environment Support**: Built-in validation for `dev`, `qa`, `uat`, `prod`, `sandbox`, `staging`.
- **Flexible High-Availability**: Configure 1 to N Availability Zones with automatic subnet allocation.
- **Cost vs Redundancy Controls**: Option for single NAT Gateway in non-prod or NAT per AZ for enterprise production.
- **Built-in Security Defaults**: Isolated database subnet tier without direct internet access; encrypted VPC flow logging enabled by default.
- **Enterprise Naming**: Automatic resource naming pattern `<project>-<environment>-<name>`.

## Usage Example

```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  project     = "acme"
  environment = "prod"
  name        = "primary-vpc"

  vpc_cidr = "10.100.0.0/16"
  azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]

  public_subnets   = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  private_subnets  = ["10.100.11.0/24", "10.100.12.0/24", "10.100.13.0/24"]
  database_subnets = ["10.100.21.0/24", "10.100.22.0/24", "10.100.23.0/24"]

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_flow_log        = true
  enable_s3_endpoint     = true

  common_tags = {
    Owner       = "Infrastructure"
    CostCenter  = "10203"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8.0 |
| aws | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether resources should be created | `bool` | `true` | no |
| `project` | Project name for naming & tagging | `string` | `"enterprise"` | no |
| `environment` | Deployment environment (dev, qa, uat, prod, sandbox, staging) | `string` | n/a | yes |
| `name` | VPC resource name | `string` | `"vpc"` | no |
| `name_prefix` | Custom override prefix | `string` | `""` | no |
| `vpc_cidr` | IPv4 CIDR block | `string` | `"10.0.0.0/16"` | no |
| `azs` | Availability zones | `list(string)` | `[]` | yes |
| `public_subnets` | Public subnet CIDRs | `list(string)` | `[]` | no |
| `private_subnets` | Private subnet CIDRs | `list(string)` | `[]` | no |
| `database_subnets` | Database subnet CIDRs | `list(string)` | `[]` | no |
| `enable_nat_gateway` | Enable NAT Gateways for private subnets | `bool` | `true` | no |
| `single_nat_gateway` | Share single NAT Gateway across subnets | `bool` | `false` | no |
| `one_nat_gateway_per_az` | One NAT Gateway per AZ | `bool` | `true` | no |
| `enable_flow_log` | Enable VPC Flow Logs | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | The ID of the VPC |
| `vpc_arn` | The ARN of the VPC |
| `vpc_cidr_block` | The CIDR block of the VPC |
| `public_subnets` | List of IDs of public subnets |
| `private_subnets` | List of IDs of private subnets |
| `database_subnets` | List of IDs of database subnets |
| `nat_public_ips` | List of NAT Gateway public IPs |

## Security Considerations

- Database subnets are non-routable to the Internet by default.
- VPC Flow Logs capture full netflow data (`ALL`) and retain logs for 90 days.
- S3 Gateway Endpoint keeps S3 traffic within AWS internal backbone network without public egress costs.
