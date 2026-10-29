module "acm_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-cert"

  domain_name       = "example.com"
  validation_method = "DNS"
}
