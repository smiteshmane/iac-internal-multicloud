module "msk_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-kafka"

  kafka_version          = "3.6.0"
  number_of_broker_nodes = 2
  instance_type          = "kafka.t3.small"
  client_subnets         = ["subnet-12345678", "subnet-87654321"]
  security_groups        = ["sg-12345678"]
}
