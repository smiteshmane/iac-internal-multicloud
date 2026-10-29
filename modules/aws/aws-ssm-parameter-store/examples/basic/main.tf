module "ssm_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-param"

  type  = "String"
  value = "example_value"
}
