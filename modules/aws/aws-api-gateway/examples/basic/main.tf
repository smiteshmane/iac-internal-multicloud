module "api_gateway_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-api"

  protocol_type = "HTTP"
  auto_deploy   = true
}
