# Private GKE Cluster Terraform Module

Production-ready Terraform module for provisioning regional, private Google Kubernetes Engine (GKE) clusters with VPC-native secondary IP alias ranges, Workload Identity, autoscaling node pools, and Control Plane Master Authorized Networks.

## Features
- **Private Nodes**: Worker nodes provisioned with private IP addresses only.
- **VPC-Native Alias IP**: Native pod and service IP allocation via secondary subnetwork CIDR ranges.
- **Workload Identity**: Native GKE Workload Identity enabled.
- **Autoscaling Node Pools**: Decoupled autoscaling node pools with Spot VM support.
- **Authorized Networks**: Restrict control plane master access to authorized CIDRs.

## Usage Example

```hcl
module "gke_cluster" {
  source = "./modules/gke-cluster"

  cluster_name = "prod-gke-cluster"
  project_id   = "my-gcp-project-123456"
  region       = "us-central1"

  network    = "projects/my-gcp-project-123456/global/networks/prod-vpc"
  subnetwork = "projects/my-gcp-project-123456/regions/us-central1/subnetworks/gke-subnet"

  ip_allocation_policy = {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  enable_private_nodes    = true
  enable_private_endpoint = false
  master_ipv4_cidr_block  = "172.16.0.0/28"

  master_authorized_networks = [
    {
      cidr_block   = "203.0.113.0/24"
      display_name = "Corporate VPN"
    }
  ]

  node_pools = [
    {
      name         = "general-pool"
      machine_type = "e2-standard-4"
      min_count    = 2
      max_count    = 10
      disk_size_gb = 100
      spot         = false
    }
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
