# Cloud SQL PostgreSQL Instance Terraform Module

Production-ready Terraform module for provisioning Google Cloud SQL PostgreSQL instances with High Availability (HA), Private Service Access, CMEK disk encryption, automated backups, SSL/TLS, and custom database flags.

## Features
- **High Availability**: Supports Regional HA across multiple zones.
- **Private IP Networking**: Private Service Access integration to prevent public database internet exposure.
- **Encryption**: Optional Customer-Managed Encryption Key (CMEK) support.
- **Backups**: Automated daily backups with Point-In-Time-Recovery (PITR) WAL log archiving.
- **Security**: Enforces SSL/TLS (`ENCRYPTED_ONLY`) connection mode and deletion protection.

## Usage Example

```hcl
module "postgres_db" {
  source = "./modules/cloud-sql-postgres"

  instance_name    = "prod-postgres-db"
  project_id       = "my-gcp-project-123456"
  region           = "us-central1"
  database_version = "POSTGRES_15"

  tier              = "db-custom-4-16384"
  availability_type = "REGIONAL"
  disk_size_gb      = 50
  
  private_network  = "projects/my-gcp-project-123456/global/networks/prod-vpc"
  enable_public_ip = false

  db_name     = "app_db"
  db_user_name = "app_user"
  db_password  = var.database_password

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
