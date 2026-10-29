module "redis_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-redis"

  node_type          = "cache.t4g.micro"
  num_cache_clusters = 1
  subnet_ids         = ["subnet-12345678"]
  security_group_ids = ["sg-12345678"]
}
