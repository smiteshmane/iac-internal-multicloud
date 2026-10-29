# AWS Application Load Balancer (ALB) Terraform Module

Production-ready Terraform module to provision AWS Application Load Balancers with multi-target group support, secure HTTPS listeners, automatic HTTP-to-HTTPS redirect rules, optional S3 access logging, and AWS WAFv2 association.

## Features

- **HTTP to HTTPS Redirect**: Standard HTTP port 80 listener configured with 301 permanent redirect to HTTPS port 443.
- **Modern TLS Policies**: Built-in default policy set to `ELBSecurityPolicy-TLS13-1-2-2021-06` for strong transport encryption.
- **Multiple Target Groups**: Provision multiple backend target groups (e.g. app, api, admin) with custom health checks.
- **WAFv2 Integration**: Attach AWS WAF Web ACL to ALB directly via `waf_web_acl_arn`.
- **Security Hardening**: Enforces `drop_invalid_header_fields = true` to protect against HTTP header injection attacks.

## Usage Example

```hcl
module "alb" {
  source = "../../modules/aws-alb"

  project     = "acme"
  environment = "prod"
  name        = "public-alb"

  subnets         = ["subnet-0123", "subnet-0456"]
  security_groups = ["sg-0789"]

  target_groups = {
    web = {
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      health_check = {
        path    = "/healthz"
        matcher = "200"
      }
    }
  }

  https_listeners = [
    {
      port             = 443
      certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"
      target_group_key = "web"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether ALB resources should be created | `bool` | `true` | no |
| `project` | Project identifier | `string` | `"enterprise"` | no |
| `environment` | Environment identifier | `string` | n/a | yes |
| `name` | ALB name | `string` | `"alb"` | no |
| `subnets` | List of subnet IDs | `list(string)` | `[]` | yes |
| `security_groups` | List of Security Group IDs | `list(string)` | `[]` | yes |
| `target_groups` | Map of target groups | `map(object)` | `{}` | no |
| `https_listeners` | List of HTTPS listeners | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `lb_id` | Load Balancer ID |
| `lb_arn` | Load Balancer ARN |
| `lb_dns_name` | Public/Internal DNS name of ALB |
| `target_group_arns` | Map of Target Group ARNs |
