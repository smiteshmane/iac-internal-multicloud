# AWS Certificate Manager (ACM) Terraform Module (`aws-acm`)

Production-ready Terraform module for requesting and managing **AWS Certificate Manager (ACM)** SSL/TLS Certificates with DNS validation.

---

## Usage Example

```hcl
module "acm" {
  source = "../../modules/aws-acm"

  project     = "enterprise"
  environment = "dev"
  name        = "app-cert"

  domain_name               = "app.yourdomain.com"
  subject_alternative_names = ["*.yourdomain.com"]
  validation_method         = "DNS"
}
```
