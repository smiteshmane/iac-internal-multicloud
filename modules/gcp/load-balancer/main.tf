resource "google_compute_global_address" "ip" {
  name    = "${var.name}-global-ip"
  project = var.project_id
}

resource "google_compute_health_check" "hc" {
  count   = var.enable_health_check ? 1 : 0
  name    = "${var.name}-health-check"
  project = var.project_id

  http_health_check {
    port         = var.health_check_port
    request_path = var.health_check_request_path
  }
}

resource "google_compute_security_policy" "cloud_armor" {
  count   = var.enable_cloud_armor ? 1 : 0
  name    = "${var.name}-security-policy"
  project = var.project_id

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

  # Block IP ranges rule if provided
  dynamic "rule" {
    for_each = length(var.blocked_ip_ranges) > 0 ? [1] : []
    content {
      action   = "deny(403)"
      priority = "1000"
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = var.blocked_ip_ranges
        }
      }
      description = "Deny blocked IP ranges"
    }
  }
}

resource "google_compute_backend_service" "backend" {
  name            = "${var.name}-backend-service"
  project         = var.project_id
  protocol        = "HTTP"
  port_name       = "http"
  timeout_sec     = 30
  health_checks   = var.enable_health_check ? [google_compute_health_check.hc[0].id] : null
  security_policy = var.enable_cloud_armor ? google_compute_security_policy.cloud_armor[0].id : null

  dynamic "backend" {
    for_each = var.backends
    content {
      group = backend.value.group
    }
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  count   = local.is_https ? 0 : 1
  name    = "${var.name}-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  count            = local.is_https ? 1 : 0
  name             = "${var.name}-https-proxy"
  project          = var.project_id
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = var.ssl_certificates
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "${var.name}-forwarding-rule"
  project    = var.project_id
  target     = local.is_https ? google_compute_target_https_proxy.https_proxy[0].id : google_compute_target_http_proxy.http_proxy[0].id
  port_range = local.is_https ? "443" : "80"
  ip_address = google_compute_global_address.ip.address
}
