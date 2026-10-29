# GCP Regional Internal Pass-Through Load Balancer Terraform Module

Production-ready Terraform module for provisioning Google Cloud Regional Internal Pass-Through TCP/UDP Load Balancers for low-latency, private microservice-to-microservice internal load balancing inside private subnets.

## Features
- **Internal Load Balancing**: Pass-through TCP/UDP load balancing inside private subnets without public IPs.
- **High Performance**: Zero-latency internal forwarding to backend instance groups.
- **Health Checking**: Automated regional TCP health checking for failover.

## Usage Example

```hcl
module "internal_lb" {
  source = "./modules/internal-load-balancer"

  name       = "prod-internal-service-lb"
  project_id = "my-gcp-project-123456"
  region     = "us-central1"
  network    = "projects/my-gcp-project-123456/global/networks/prod-vpc-network"
  subnetwork = "projects/my-gcp-project-123456/regions/us-central1/subnetworks/prod-app-subnet"

  ports             = ["8080"]
  health_check_port = 8080
}
```
