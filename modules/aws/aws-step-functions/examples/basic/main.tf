module "step_functions_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-workflow"

  type = "STANDARD"
}
