# AWS Lambda Terraform Module (`aws-lambda`)

Production-ready Terraform module for provisioning **AWS Lambda Functions** with IAM Execution Roles, CloudWatch Log Groups, VPC integration, and Environment Variables.

---

## Features

- Dynamic IAM Execution Role creation with AWSLambdaBasicExecutionRole & VPC Access policies.
- Dedicated CloudWatch Log Group with configurable retention.
- Supports VPC placement (`subnet_ids` and `security_group_ids`).
- Pre-packaged zip bootstrap handler for zero-dependency initialization.

---

## Usage Example

```hcl
module "lambda" {
  source = "../../modules/aws-lambda"

  project     = "enterprise"
  environment = "dev"
  name        = "api-handler"

  runtime     = "python3.12"
  handler     = "index.handler"
  memory_size = 256
  timeout     = 30

  environment_variables = {
    ENVIRONMENT = "dev"
    DB_HOST     = "postgres.dev.local"
  }
}
```
