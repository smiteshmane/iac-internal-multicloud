# GCP Standalone VPC Subnet Terraform Module

Production-ready Terraform module for provisioning standalone Google Cloud VPC Subnetworks into existing custom VPC networks, with support for secondary IP alias ranges (GKE Pods/Services), VPC Flow Logs, Private Google Access, and IAM network user bindings.

## Features
- **Standalone Management**: Provision dedicated regional subnets independently of the parent VPC network shell.
- **Secondary CIDR Ranges**: Native secondary alias IP ranges for GKE pods and services.
- **VPC Flow Logs**: Optional logging configuration with customizable sampling intervals.
- **IAM Security**: Fine-grained `roles/compute.networkUser` member bindings for project teams and service accounts.

## Usage Example

```hcl
module "gke_subnet" {
  source = "./modules/vpc-subnet"

  subnet_name   = "prod-gke-subnet"
  project_id    = "my-gcp-project-123456"
  region        = "us-central1"
  network       = "projects/my-gcp-project-123456/global/networks/prod-vpc-network"
  ip_cidr_range = "10.10.0.0/20"

  private_ip_google_access = true

  secondary_ip_ranges = [
    {
      range_name    = "gke-pods"
      ip_cidr_range = "10.20.0.0/14"
    },
    {
      range_name    = "gke-services"
      ip_cidr_range = "10.30.0.0/20"
    }
  ]

  enable_flow_logs = true

  network_users = [
    "serviceAccount:gke-cluster-sa@my-gcp-project-123456.iam.gserviceaccount.com"
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
