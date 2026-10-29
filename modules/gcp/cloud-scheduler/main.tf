resource "google_cloud_scheduler_job" "job" {
  name        = var.name
  project     = var.project_id
  region      = var.region
  schedule    = var.schedule
  time_zone   = var.time_zone
  description = var.description

  dynamic "http_target" {
    for_each = local.is_http ? [var.http_target] : []
    content {
      uri         = http_target.value.uri
      http_method = http_target.value.http_method
      body        = http_target.value.body != null ? base64encode(http_target.value.body) : null
      headers     = http_target.value.headers

      dynamic "oidc_token" {
        for_each = http_target.value.oidc_token != null ? [http_target.value.oidc_token] : []
        content {
          service_account_email = oidc_token.value.service_account_email
          audience              = oidc_token.value.audience != null ? oidc_token.value.audience : http_target.value.uri
        }
      }
    }
  }
}
