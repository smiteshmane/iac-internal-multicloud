module "cloudfront_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-cdn"

  origin_domain_name = "example.com"
}
