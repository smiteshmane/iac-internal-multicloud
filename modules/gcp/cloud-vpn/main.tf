resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  name    = local.gateway_name
  project = var.project_id
  region  = var.region
  network = var.network
}

resource "google_compute_router" "router" {
  name    = local.router_name
  project = var.project_id
  region  = var.region
  network = var.network

  bgp {
    asn = var.bgp_asn
  }
}

resource "google_compute_vpn_tunnel" "tunnels" {
  for_each = { for tunnel in var.tunnels : tunnel.name => tunnel }

  name                  = each.value.name
  project               = var.project_id
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway.id
  vpn_gateway_interface = each.value.vpn_gateway_interface
  peer_ip               = each.value.peer_external_ip
  shared_secret         = each.value.shared_secret
  router                = google_compute_router.router.id
}
