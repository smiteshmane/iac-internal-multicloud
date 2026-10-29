# GCP Cloud Run v2 Terraform Module

Production-ready Terraform module for provisioning Google Cloud Run v2 serverless container services with autoscaling, VPC Connector integration, environment variables, custom resource limits, and IAM invoker role bindings.

## Features
- **Serverless Autoscaling**: Fine-grained `min_instances` and `max_instances` controls.
- **VPC Integration**: Direct Serverless VPC Access connector integration.
- **Traffic Routing & Ingress**: Ingress policies (`INGRESS_TRAFFIC_ALL`, `INGRESS_TRAFFIC_INTERNAL_ONLY`, `INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER`).
- **IAM Security**: Granular `roles/run.invoker` member bindings for public (`allUsers`) or private access.

## Usage Example

```hcl
module "api_service" {
  source = "./modules/cloud-run"

  service_name    = "prod-backend-api"
  project_id      = "my-gcp-project-123456"
  location        = "us-central1"
  container_image = "us-central1-docker.pkg.dev/my-gcp-project-123456/prod-app-containers/backend-api:latest"

  cpu_limit     = "1000m"
  memory_limit  = "1Gi"
  min_instances = 1
  max_instances = 20

  env_vars = {
    ENVIRONMENT = "production"
    LOG_LEVEL   = "INFO"
  }

  invokers = ["allUsers"] # Public HTTPS service

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
