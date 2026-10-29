# AWS CloudFront Terraform Module (`aws-cloudfront`)

Production-ready Terraform module for provisioning **Amazon CloudFront Distributions** with HTTP to HTTPS redirects, configurable TTLs, and price classes.

---

## Usage Example

```hcl
module "cdn" {
  source = "../../modules/aws-cloudfront"

  project     = "enterprise"
  environment = "dev"
  name        = "app-cdn"

  origin_domain_name  = module.alb.lb_dns_name
  origin_id           = "ALBOrigin"
  default_root_object = "index.html"
}
```
