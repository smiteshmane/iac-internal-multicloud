resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  project                  = var.project_id
  region                   = var.region
  network                  = var.network
  ip_cidr_range            = var.ip_cidr_range
  private_ip_google_access = var.private_ip_google_access

  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = var.enable_flow_logs ? [var.flow_logs_config] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
    }
  }
}

resource "google_compute_subnetwork_iam_member" "network_users" {
  for_each = toset(var.network_users)

  project    = google_compute_subnetwork.subnet.project
  region     = google_compute_subnetwork.subnet.region
  subnetwork = google_compute_subnetwork.subnet.name
  role       = "roles/compute.networkUser"
  member     = each.value
}
