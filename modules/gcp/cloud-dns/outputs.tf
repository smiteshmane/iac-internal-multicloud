output "zone_name" {
  description = "The name of the managed DNS zone."
  value       = google_dns_managed_zone.zone.name
}

output "dns_name" {
  description = "The DNS name of the zone."
  value       = google_dns_managed_zone.zone.dns_name
}

output "name_servers" {
  description = "List of authoritative name servers for the DNS zone."
  value       = google_dns_managed_zone.zone.name_servers
}
