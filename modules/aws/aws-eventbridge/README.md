# AWS EventBridge Terraform Module (`aws-eventbridge`)

Production-ready Terraform module for provisioning **Amazon EventBridge Custom EventBuses**, Event Rules, and Target Integrations.

---

## Usage Example

```hcl
module "eventbridge" {
  source = "../../modules/aws-eventbridge"

  project     = "enterprise"
  environment = "dev"
  name        = "app-events"

  create_event_bus    = true
  schedule_expression = "rate(5 minutes)"
  target_arn          = module.lambda.function_arn
}
```
