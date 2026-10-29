locals {
  is_https = length(var.ssl_certificates) > 0
}
