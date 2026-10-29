resource "google_compute_region_health_check" "hc" {
  name    = local.hc_name
  project = var.project_id
  region  = var.region

  tcp_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_region_backend_service" "backend" {
  name                  = local.backend_name
  project               = var.project_id
  region                = var.region
  network               = var.network
  load_balancing_scheme = "INTERNAL"
  protocol              = "TCP"
  health_checks         = [google_compute_region_health_check.hc.id]

  dynamic "backend" {
    for_each = var.backends
    content {
      group = backend.value.group
    }
  }
}

resource "google_compute_forwarding_rule" "forwarding_rule" {
  name                  = "${var.name}-forwarding-rule"
  project               = var.project_id
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.backend.id
  ports                 = var.ports
  ip_protocol           = "TCP"
  ip_address            = var.ip_address
}
