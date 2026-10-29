resource "google_compute_security_policy" "policy" {
  name        = var.policy_name
  project     = var.project_id
  description = var.description

  # Default rule allow all
  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow rule"
  }

  # Whitelist IP Ranges rule (Priority 100)
  dynamic "rule" {
    for_each = local.is_whitelisted ? [1] : []
    content {
      action   = "allow"
      priority = "100"
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = var.allowed_ip_ranges
        }
      }
      description = "Explicitly allowed IP ranges"
    }
  }

  # Blacklist IP Ranges rule (Priority 200)
  dynamic "rule" {
    for_each = local.is_blacklisted ? [1] : []
    content {
      action   = "deny(403)"
      priority = "200"
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = var.blocked_ip_ranges
        }
      }
      description = "Explicitly blocked IP ranges"
    }
  }

  # OWASP SQLi Protection Rule (Priority 1000)
  dynamic "rule" {
    for_each = var.enable_owasp_rules ? [1] : []
    content {
      action   = "deny(403)"
      priority = "1000"
      match {
        expr {
          expression = "evaluatePreconfiguredExpr('sqli-v33-stable')"
        }
      }
      description = "OWASP SQL Injection protection"
    }
  }

  # OWASP XSS Protection Rule (Priority 1001)
  dynamic "rule" {
    for_each = var.enable_owasp_rules ? [1] : []
    content {
      action   = "deny(403)"
      priority = "1001"
      match {
        expr {
          expression = "evaluatePreconfiguredExpr('xss-v33-stable')"
        }
      }
      description = "OWASP Cross-Site Scripting (XSS) protection"
    }
  }

  # Rate Limiting Rule (Priority 3000)
  dynamic "rule" {
    for_each = var.enable_rate_limiting ? [1] : []
    content {
      action   = "rate_based_ban"
      priority = "3000"
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = ["*"]
        }
      }
      rate_limit_options {
        conform_action = "allow"
        exceed_action  = "deny(429)"
        enforce_on_key = "IP"
        rate_limit_threshold {
          count        = var.rate_limit_count
          interval_sec = var.rate_limit_interval_sec
        }
        ban_duration_sec = 300
      }
      description = "Rate limiting ban rule"
    }
  }
}
