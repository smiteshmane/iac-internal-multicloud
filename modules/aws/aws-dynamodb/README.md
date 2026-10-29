# AWS DynamoDB Terraform Module (`aws-dynamodb`)

Production-ready Terraform module for provisioning **Amazon DynamoDB Tables** with `PAY_PER_REQUEST` billing mode, Point-In-Time Recovery (PITR), and mandatory server-side encryption (SSE).

---

## Features

- Supports `PAY_PER_REQUEST` and `PROVISIONED` billing modes.
- Configurable Hash and Range keys.
- Point-In-Time Recovery (PITR) enabled by default.
- Server-Side Encryption (SSE) enabled by default.

---

## Usage Example

```hcl
module "dynamodb" {
  source = "../../modules/aws-dynamodb"

  project     = "enterprise"
  environment = "dev"
  name        = "app-users"

  hash_key     = "userId"
  billing_mode = "PAY_PER_REQUEST"

  attributes = [
    {
      name = "userId"
      type = "S"
    }
  ]
}
```
