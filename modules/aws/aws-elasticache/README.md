# AWS ElastiCache Redis Terraform Module (`aws-elasticache`)

Production-ready Terraform module for provisioning **Amazon ElastiCache Redis Replication Groups** with transit TLS & at-rest encryption, subnet groups, and parameter groups.

---

## Features

- Configurable node types (`cache.t4g.micro`, `cache.m6g.large`).
- At-rest and transit (TLS) encryption enabled by default.
- Subnet group and parameter group management.
- Multi-AZ automatic failover option.

---

## Usage Example

```hcl
module "redis" {
  source = "../../modules/aws-elasticache"

  project     = "enterprise"
  environment = "dev"
  name        = "session-store"

  node_type          = "cache.t4g.micro"
  num_cache_clusters = 1
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.redis_sg.security_group_id]
}
```
