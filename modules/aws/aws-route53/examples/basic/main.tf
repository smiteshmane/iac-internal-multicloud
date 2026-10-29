module "route53_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  domain_name = "example.com"
}
