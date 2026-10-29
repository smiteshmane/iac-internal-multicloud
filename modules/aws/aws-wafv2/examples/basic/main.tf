module "waf_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-waf"

  scope                  = "REGIONAL"
  enable_common_rule_set = true
  enable_rate_limit_rule = true
  rate_limit             = 2000
}
