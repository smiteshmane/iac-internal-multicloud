# AWS MSK (Managed Streaming for Kafka) Terraform Module (`aws-msk`)

Production-ready Terraform module for provisioning **Amazon Managed Streaming for Apache Kafka (MSK)** clusters with TLS in-transit encryption, EBS storage, and VPC subnets.

---

## Usage Example

```hcl
module "kafka" {
  source = "../../modules/aws-msk"

  project     = "enterprise"
  environment = "dev"
  name        = "event-stream"

  kafka_version          = "3.6.0"
  number_of_broker_nodes = 2
  instance_type          = "kafka.t3.small"
  client_subnets         = module.vpc.private_subnets
  security_groups        = [module.kafka_sg.security_group_id]
}
```
