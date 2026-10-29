module "eks_example" {
  source = "../../"

  project     = var.project
  environment = var.environment
  name        = "example-cluster"

  kubernetes_version      = "1.30"
  subnet_ids              = ["subnet-12345678", "subnet-87654321"]
  instance_types          = ["t3.medium"]
  node_group_desired_size = 2
  node_group_min_size     = 1
  node_group_max_size     = 3
}
