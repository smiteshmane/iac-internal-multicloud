output "gateway_name" {
  description = "The name of the HA VPN Gateway."
  value       = google_compute_ha_vpn_gateway.ha_gateway.name
}

output "gateway_id" {
  description = "The fully qualified resource path of the HA VPN Gateway."
  value       = google_compute_ha_vpn_gateway.ha_gateway.id
}

output "vpn_interfaces" {
  description = "Map of public IP addresses assigned to the HA VPN Gateway interfaces."
  value       = google_compute_ha_vpn_gateway.ha_gateway.vpn_interfaces
}

output "router_name" {
  description = "The name of the associated BGP Cloud Router."
  value       = google_compute_router.router.name
}
