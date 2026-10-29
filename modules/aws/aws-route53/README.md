# AWS Route 53 Terraform Module (`aws-route53`)

Production-ready Terraform module for provisioning **Amazon Route 53 Hosted Zones** (Public & Private) and managing DNS Records (A, AAAA, CNAME, Alias).

---

## Features

- Supports both Public and Private Hosted Zones.
- Custom A/AAAA/CNAME record sets.
- ALB / CloudFront Alias record support.

---

## Usage Example

```hcl
module "route53" {
  source = "../../modules/aws-route53"

  project     = "enterprise"
  environment = "dev"
  domain_name = "yourdomain.com"

  records = [
    {
      name = "app.yourdomain.com"
      type = "A"
      alias = {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
      }
    }
  ]
}
```
