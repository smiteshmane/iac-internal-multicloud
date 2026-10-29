# AWS RDS Terraform Module

Enterprise-grade Terraform module for managing AWS Relational Database Service (RDS) instances enforcing Multi-AZ HA topology, KMS storage encryption at rest, Performance Insights, Enhanced Monitoring, custom Parameter Groups, automated backups, and deletion protection.

## Features

- **Multi-AZ High Availability**: Toggle synchronous secondary standby instance creation in another Availability Zone.
- **Security & Encryption**: Mandatory storage encryption (`storage_encrypted = true`) using Customer Managed Keys (CMK) or AWS managed keys.
- **Enhanced Monitoring & Performance Insights**: Creates IAM role for OS-level metrics and enables Performance Insights telemetry.
- **Auto-Scaling Storage**: Supports `max_allocated_storage` for automatic storage expansion.
- **Deletion Protection**: Enabled by default to prevent accidental database teardown.

## Usage Example

```hcl
module "rds" {
  source = "../../modules/aws-rds"

  project     = "acme"
  environment = "prod"
  name        = "main-postgres"

  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t4g.large"

  allocated_storage     = 50
  max_allocated_storage = 200
  multi_az              = true

  db_name  = "production_db"
  username = "masteradmin"

  subnet_ids             = ["subnet-0123", "subnet-0456"]
  vpc_security_group_ids = ["sg-0789"]

  deletion_protection = true
  skip_final_snapshot = false

  parameter_group_family = "postgres15"
  parameters = [
    {
      name  = "rds.force_ssl"
      value = "1"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether to create RDS resources | `bool` | `true` | no |
| `project` | Project identifier | `string` | `"enterprise"` | no |
| `environment` | Environment identifier | `string` | n/a | yes |
| `engine` | Database engine | `string` | `"postgres"` | no |
| `engine_version` | Engine version | `string` | `"15.4"` | no |
| `instance_class` | DB instance type | `string` | `"db.t4g.medium"` | no |
| `multi_az` | Enable Multi-AZ | `bool` | `true` | no |
| `subnet_ids` | Subnet IDs for subnet group | `list(string)` | `[]` | yes |
| `vpc_security_group_ids` | Security group IDs | `list(string)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `db_instance_address` | Hostname of DB instance |
| `db_instance_endpoint` | Connection endpoint |
| `db_instance_identifier` | DB instance identifier |
