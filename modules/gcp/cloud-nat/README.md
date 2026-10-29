# Standalone GCP Cloud NAT Gateway Terraform Module

Production-ready Terraform module for provisioning standalone Google Cloud Routers and Cloud NAT Gateways into existing VPC networks, with support for automatic IP allocation or static reserved IP addresses.

## Features
- **Outbound Internet Egress**: Allows VMs & containers in private subnets without public IPs to safely access external software repositories & APIs.
- **Static IP Allocation**: Option to reserve static external IP addresses for IP whitelisting at third-party APIs.
- **Logging & Visibility**: Configurable NAT log filtering (`ERRORS_ONLY`, `ALL`).

## Usage Example

```hcl
module "standalone_nat" {
  source = "./modules/cloud-nat"

  nat_name       = "prod-app-nat"
  project_id     = "my-gcp-project-123456"
  region         = "us-central1"
  network        = "projects/my-gcp-project-123456/global/networks/prod-vpc-network"
  num_static_ips = 2 # Reserve 2 static IPs for outbound firewall whitelisting
  log_filter     = "ERRORS_ONLY"
}
```
