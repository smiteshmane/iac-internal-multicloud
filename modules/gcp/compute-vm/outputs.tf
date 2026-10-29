output "instance_name" {
  description = "The name of the created VM instance."
  value       = google_compute_instance.vm.name
}

output "instance_id" {
  description = "The server-assigned unique identifier of the VM instance."
  value       = google_compute_instance.vm.instance_id
}

output "self_link" {
  description = "The URI self_link of the VM instance."
  value       = google_compute_instance.vm.self_link
}

output "internal_ip" {
  description = "The internal IP address allocated to the VM primary network interface."
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "external_ip" {
  description = "The external public IP address assigned to the VM (if enable_public_ip is true)."
  value       = length(google_compute_instance.vm.network_interface[0].access_config) > 0 ? google_compute_instance.vm.network_interface[0].access_config[0].nat_ip : null
}
