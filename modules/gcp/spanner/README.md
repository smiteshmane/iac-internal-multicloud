# GCP Cloud Spanner Relational Database Terraform Module

Production-ready Terraform module for provisioning Google Cloud Spanner multi-region/regional SQL database instances, processing unit allocation, declarative DDL schema migrations, and `roles/spanner.databaseUser` IAM bindings.

## Features
- **High Availability**: Multi-region & regional Spanner configuration (`regional-us-central1`, `nam3`).
- **Processing Units**: Cost-optimized processing unit allocation (100, 500, 1000 units).
- **Declarative DDL**: Automatic database table schema execution.
- **IAM Security**: Fine-grained `roles/spanner.databaseUser` bindings for microservices.

## Usage Example

```hcl
module "spanner_db" {
  source = "./modules/spanner"

  instance_name    = "prod-global-db"
  project_id       = "my-gcp-project-123456"
  config           = "regional-us-central1"
  processing_units = 100

  databases = [
    {
      name = "orders_db"
      ddl = [
        "CREATE TABLE Orders (OrderId STRING(36) NOT NULL, Amount NUMERIC) PRIMARY KEY(OrderId)"
      ]
    }
  ]

  database_users = [
    "serviceAccount:order-api-sa@my-gcp-project-123456.iam.gserviceaccount.com"
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
