module "sns_sqs_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-events"

  enable_sns_topic     = true
  enable_sqs_queue     = true
  enable_dlq           = true
  subscribe_sqs_to_sns = true
}
