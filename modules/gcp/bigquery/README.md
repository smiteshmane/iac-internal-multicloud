# GCP BigQuery Datasets & Tables Terraform Module

Production-ready Terraform module for provisioning Google Cloud BigQuery datasets and tables with JSON schema management, time-based partitioning, clustering, CMEK encryption, and dataset lifecycle rules.

## Features
- **Datasets & Tables**: Production datasets and time-partitioned tables.
- **CMEK Encryption**: Optional Cloud KMS Customer-Managed Encryption Key support.
- **Partitioning & Clustering**: Partitioning by timestamp/date fields and clustering for query optimization.

## Usage Example

```hcl
module "analytics_dw" {
  source = "./modules/bigquery"

  dataset_id  = "prod_analytics_dw"
  project_id  = "my-gcp-project-123456"
  location    = "US"
  description = "Production Data Warehouse Dataset"

  tables = [
    {
      table_id                = "user_events"
      schema                  = file("${path.module}/schemas/user_events.json")
      time_partitioning_field = "event_timestamp"
      clustering              = ["user_id", "event_type"]
    }
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
