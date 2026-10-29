module "opensearch_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-search"

  engine_version = "OpenSearch_2.11"
  instance_type  = "t3.small.search"
  instance_count = 1
}
