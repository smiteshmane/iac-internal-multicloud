# AWS WAFv2 Terraform Module (`aws-wafv2`)

Production-ready Terraform module for provisioning **AWS WAFv2 Web ACLs** with pre-configured managed rules (Common Rule Set, Known Bad Inputs, SQL Injection) and IP Rate Limiting.

---

## Features

- Managed OWASP Top 10 Security rules (`AWSManagedRulesCommonRuleSet`).
- Known Bad Inputs protection (`AWSManagedRulesKnownBadInputsRuleSet`).
- SQL Injection protection (`AWSManagedRulesSQLiRuleSet`).
- Configurable IP Rate Limiting.
- Automatic ALB & API Gateway Resource Association (`associated_resource_arns`).
- Supports both `REGIONAL` and `CLOUDFRONT` scopes.

---

## Usage Example

```hcl
module "waf" {
  source = "../../modules/aws-wafv2"

  project     = "enterprise"
  environment = "dev"
  name        = "alb-waf"

  scope                     = "REGIONAL"
  enable_common_rule_set    = true
  enable_rate_limit_rule    = true
  rate_limit                = 2000
  associated_resource_arns = [module.alb.lb_arn]
}
```
