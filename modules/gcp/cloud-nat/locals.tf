locals {
  router_name    = "${var.nat_name}-router"
  use_static_ips = var.num_static_ips > 0
}
