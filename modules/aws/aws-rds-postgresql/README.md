# AWS RDS PostgreSQL Terraform Module

Dedicated enterprise-grade Terraform module for managing Amazon RDS PostgreSQL instances enforcing Multi-AZ HA topology, storage encryption at rest, mandatory SSL connection enforcement (`rds.force_ssl = 1`), Enhanced Monitoring, and Performance Insights telemetry.

## Features

- **Engine Optimized**: Hardcoded for `postgres` engine with configurable versions (14, 15, 16).
- **Mandatory SSL Enforcement**: Pre-injects `rds.force_ssl = 1` into the Parameter Group to mandate client TLS transport encryption.
- **Multi-AZ High Availability**: Provides zero-downtime failover across availability zones.
- **Enhanced Monitoring**: Automatically attaches IAM role for detailed OS metric collection.

## Usage Example

```hcl
module "postgres" {
  source = "../../modules/aws-rds-postgresql"

  project     = "acme"
  environment = "prod"
  name        = "app-postgres"

  engine_version = "15.4"
  instance_class = "db.t4g.large"

  allocated_storage     = 50
  max_allocated_storage = 200
  multi_az              = true

  db_name  = "application_db"
  username = "pgadmin"

  subnet_ids             = ["subnet-0123", "subnet-0456"]
  vpc_security_group_ids = ["sg-0789"]

  deletion_protection = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether DB resources are created | `bool` | `true` | no |
| `project` | Project name | `string` | `"enterprise"` | no |
| `environment` | Deployment environment | `string` | n/a | yes |
| `engine_version` | PostgreSQL version | `string` | `"15.4"` | no |
| `instance_class` | Instance class | `string` | `"db.t4g.medium"` | no |
| `subnet_ids` | Subnet IDs for subnet group | `list(string)` | `[]` | yes |
| `vpc_security_group_ids` | Security group IDs | `list(string)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `db_instance_address` | Hostname of DB instance |
| `db_instance_endpoint` | Connection endpoint |
| `db_instance_identifier` | DB instance identifier |
