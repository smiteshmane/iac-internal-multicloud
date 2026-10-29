locals {
  is_whitelisted = length(var.allowed_ip_ranges) > 0
  is_blacklisted = length(var.blocked_ip_ranges) > 0
}
