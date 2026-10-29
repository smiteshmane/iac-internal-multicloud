# VPC Network & Custom Subnets Terraform Module

Production-ready Terraform module for provisioning Google Cloud Custom VPC Networks, Subnetworks with secondary IP alias ranges (Pods & Services), and automated Cloud NAT Gateway for private egress.

## Features
- **Custom Mode VPC**: Explicit subnetwork management without default subnetwork creation.
- **Secondary CIDR Ranges**: Native support for secondary IP ranges per subnetwork (ideal for GKE Pods and Services).
- **Cloud NAT**: Automated Cloud Router & Cloud NAT deployment for private subnets.
- **Private Google Access**: Enables private instances to access Google APIs without public IPs.

## Usage Example

```hcl
module "vpc" {
  source = "./modules/vpc-network"

  network_name = "prod-vpc-network"
  project_id   = "my-gcp-project-123456"
  routing_mode = "GLOBAL"

  subnets = [
    {
      name                     = "gke-subnet"
      region                   = "us-central1"
      ip_cidr_range            = "10.0.0.0/20"
      private_ip_google_access = true
      secondary_ip_ranges = [
        {
          range_name    = "gke-pods"
          ip_cidr_range = "10.4.0.0/14"
        },
        {
          range_name    = "gke-services"
          ip_cidr_range = "10.8.0.0/20"
        }
      ]
    }
  ]

  enable_cloud_nat = true
  nat_region       = "us-central1"
}
```
