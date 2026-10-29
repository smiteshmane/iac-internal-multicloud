module "lambda_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-function"

  runtime     = "python3.12"
  memory_size = 128
  timeout     = 30
}
