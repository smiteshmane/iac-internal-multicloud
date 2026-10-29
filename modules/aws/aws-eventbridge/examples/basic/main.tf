module "eventbridge_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-bus"

  create_event_bus    = true
  schedule_expression = "rate(5 minutes)"
}
