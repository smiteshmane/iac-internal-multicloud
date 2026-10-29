# AWS Step Functions Terraform Module (`aws-step-functions`)

Production-ready Terraform module for provisioning **AWS Step Functions State Machines** (Standard and Express) with IAM execution roles and Amazon States Language (ASL) definitions.

---

## Usage Example

```hcl
module "step_functions" {
  source = "../../modules/aws-step-functions"

  project     = "enterprise"
  environment = "dev"
  name        = "order-workflow"

  type = "STANDARD"
}
```
