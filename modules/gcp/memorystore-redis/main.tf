resource "google_redis_instance" "redis" {
  name                    = var.instance_id
  project                 = var.project_id
  region                  = var.region
  tier                    = var.tier
  memory_size_gb          = var.memory_size_gb
  redis_version           = var.redis_version
  authorized_network      = var.authorized_network
  auth_enabled            = var.auth_enabled
  transit_encryption_mode = var.transit_encryption_mode
  redis_configs           = var.redis_configs
  labels                  = local.labels
}
