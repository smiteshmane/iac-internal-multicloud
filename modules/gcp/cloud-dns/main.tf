resource "google_dns_managed_zone" "zone" {
  name        = var.zone_name
  project     = var.project_id
  dns_name    = var.dns_name
  description = var.description
  visibility  = var.visibility
  labels      = local.labels

  dynamic "private_visibility_config" {
    for_each = local.is_private && length(var.private_visibility_networks) > 0 ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.private_visibility_networks
        content {
          network_url = networks.value
        }
      }
    }
  }
}

resource "google_dns_record_set" "recordsets" {
  for_each = { for record in var.recordsets : "${record.name}/${record.type}" => record }

  name         = endswith(each.value.name, ".") ? each.value.name : "${each.value.name}.${var.dns_name}"
  project      = var.project_id
  managed_zone = google_dns_managed_zone.zone.name
  type         = each.value.type
  ttl          = each.value.ttl
  rrdatas      = each.value.records
}
