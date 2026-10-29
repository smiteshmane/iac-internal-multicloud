# GCP Cloud MemoryStore Redis Terraform Module

Production-ready Terraform module for provisioning Google Cloud MemoryStore Redis cache clusters with High Availability (HA) failover, TLS in-transit encryption, AUTH password authentication, and private VPC network peering.

## Features
- **High Availability**: `STANDARD_HA` multi-zone automatic failover tier.
- **Security & TLS**: TLS in-transit encryption (`SERVER_AUTHENTICATION`) and AUTH password enforcement.
- **Custom Configuration**: Configurable `maxmemory-policy` and Redis memory parameters.

## Usage Example

```hcl
module "redis_cache" {
  source = "./modules/memorystore-redis"

  instance_id        = "prod-app-cache"
  project_id         = "my-gcp-project-123456"
  region             = "us-central1"
  tier               = "STANDARD_HA"
  memory_size_gb     = 2
  authorized_network = "projects/my-gcp-project-123456/global/networks/prod-vpc-network"

  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"

  redis_configs = {
    maxmemory-policy = "allkeys-lru"
  }

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
