resource "google_compute_router" "router" {
  name    = local.router_name
  project = var.project_id
  region  = var.region
  network = var.network
}

resource "google_compute_address" "nat_ips" {
  count   = var.num_static_ips
  name    = "${var.nat_name}-ip-${count.index}"
  project = var.project_id
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name    = var.nat_name
  project = var.project_id
  router  = google_compute_router.router.name
  region  = var.region

  nat_ip_allocate_option             = local.use_static_ips ? "MANUAL_ONLY" : "AUTO_ONLY"
  nat_ips                            = local.use_static_ips ? google_compute_address.nat_ips[*].self_link : null
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = var.log_filter
  }
}
