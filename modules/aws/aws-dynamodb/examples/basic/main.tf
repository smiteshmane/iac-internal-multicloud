module "dynamodb_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-table"

  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}
