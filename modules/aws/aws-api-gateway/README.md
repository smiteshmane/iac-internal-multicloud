# AWS API Gateway v2 Terraform Module (`aws-api-gateway`)

Production-ready Terraform module for provisioning **Amazon API Gateway v2 (HTTP API)** with automatic stage deployment and CloudWatch access logging.

---

## Features

- High-performance HTTP API Gateway v2.
- Auto-deploy stage settings (`$default` stage).
- Structured JSON CloudWatch Access Logging.

---

## Usage Example

```hcl
module "api_gateway" {
  source = "../../modules/aws-api-gateway"

  project     = "enterprise"
  environment = "dev"
  name        = "http-gateway"

  protocol_type = "HTTP"
  auto_deploy   = true
}
```
