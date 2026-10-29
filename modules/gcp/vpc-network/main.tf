resource "google_compute_network" "vpc" {
  name                            = var.network_name
  project                         = var.project_id
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes_on_create
}

resource "google_compute_subnetwork" "subnets" {
  for_each = { for subnet in var.subnets : "${subnet.region}/${subnet.name}" => subnet }

  name                     = each.value.name
  project                  = var.project_id
  region                   = each.value.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = each.value.ip_cidr_range
  private_ip_google_access = each.value.private_ip_google_access

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

resource "google_compute_firewall" "allow_iap_ssh" {
  count   = var.allow_iap_ssh ? 1 : 0
  name    = "${var.network_name}-allow-iap-ssh"
  project = var.project_id
  network = google_compute_network.vpc.id

  description = "Allow SSH access from GCP Console Identity-Aware Proxy (IAP) range."

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.iap_source_ranges
}

resource "google_compute_firewall" "custom_rules" {
  for_each = { for rule in var.custom_firewall_rules : rule.name => rule }

  name          = "${var.network_name}-${each.value.name}"
  project       = var.project_id
  network       = google_compute_network.vpc.id
  direction     = each.value.direction
  priority      = each.value.priority
  source_ranges = length(each.value.source_ranges) > 0 ? each.value.source_ranges : null
  target_tags   = length(each.value.target_tags) > 0 ? each.value.target_tags : null

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}

resource "google_compute_router" "router" {
  count   = var.enable_cloud_nat ? 1 : 0
  name    = local.router_name
  project = var.project_id
  region  = var.nat_region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  count                              = var.enable_cloud_nat ? 1 : 0
  name                               = local.nat_name
  project                            = var.project_id
  router                             = google_compute_router.router[0].name
  region                             = var.nat_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
