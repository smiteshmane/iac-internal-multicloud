# Advanced Cloud Armor WAF & OWASP Rules Terraform Module

Production-ready Terraform module for provisioning Google Cloud Armor Web Application Firewall (WAF) Security Policies with pre-configured OWASP Top 10 rulesets (SQLi, XSS, RCE), rate limiting thresholds, and IP blacklist/whitelist rules.

## Features
- **OWASP Protection**: Pre-configured SQL Injection (`sqli-v33-stable`) & Cross-Site Scripting (`xss-v33-stable`) protection.
- **Rate Limiting**: Rate-based ban threshold enforcement (e.g. 100 requests per 60s, ban for 5 minutes).
- **IP Control**: Explicit IP whitelisting and blacklisting.

## Usage Example

```hcl
module "waf" {
  source = "./modules/cloud-armor"

  policy_name = "prod-web-waf-policy"
  project_id  = "my-gcp-project-123456"

  enable_owasp_rules      = true
  enable_rate_limiting    = true
  rate_limit_count        = 100
  rate_limit_interval_sec = 60

  blocked_ip_ranges = [
    "198.51.100.0/24"
  ]
}
```
