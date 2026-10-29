# AWS OpenSearch Terraform Module (`aws-opensearch`)

Production-ready Terraform module for provisioning **Amazon OpenSearch Service Domains** with node-to-node encryption, at-rest encryption, TLS enforcement, and VPC integration.

---

## Usage Example

```hcl
module "opensearch" {
  source = "../../modules/aws-opensearch"

  project     = "enterprise"
  environment = "dev"
  name        = "app-search"

  engine_version = "OpenSearch_2.11"
  instance_type  = "t3.small.search"
  instance_count = 1
  volume_size    = 20
}
```
