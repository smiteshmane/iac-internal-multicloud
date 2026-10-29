# WAFv2 Web ACL Resource
resource "aws_wafv2_web_acl" "this" {
  count = var.create ? 1 : 0

  name        = local.name_prefix
  description = var.description
  scope       = var.scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = replace("${local.name_prefix}-webacl", "-", "")
    sampled_requests_enabled   = true
  }

  # Rule 1: AWS Managed Common Rule Set
  dynamic "rule" {
    for_each = var.enable_common_rule_set ? [1] : []
    content {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = 10

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesCommonRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = replace("${local.name_prefix}-common-rules", "-", "")
        sampled_requests_enabled   = true
      }
    }
  }

  # Rule 2: AWS Managed Known Bad Inputs Rule Set
  dynamic "rule" {
    for_each = var.enable_known_bad_inputs_rule_set ? [1] : []
    content {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = 20

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesKnownBadInputsRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = replace("${local.name_prefix}-bad-inputs", "-", "")
        sampled_requests_enabled   = true
      }
    }
  }

  # Rule 3: AWS Managed SQL Database Rule Set
  dynamic "rule" {
    for_each = var.enable_sqli_rule_set ? [1] : []
    content {
      name     = "AWSManagedRulesSQLiRuleSet"
      priority = 30

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesSQLiRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = replace("${local.name_prefix}-sqli-rules", "-", "")
        sampled_requests_enabled   = true
      }
    }
  }

  # Rule 4: Rate Limiting Rule
  dynamic "rule" {
    for_each = var.enable_rate_limit_rule ? [1] : []
    content {
      name     = "IPRateLimitingRule"
      priority = 40

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = var.rate_limit
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = replace("${local.name_prefix}-rate-limit", "-", "")
        sampled_requests_enabled   = true
      }
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# Regional Resource Associations (e.g. ALB)
resource "aws_wafv2_web_acl_association" "this" {
  count = var.create && var.scope == "REGIONAL" ? length(var.associated_resource_arns) : 0

  resource_arn = var.associated_resource_arns[count.index]
  web_acl_arn  = aws_wafv2_web_acl.this[0].arn
}
