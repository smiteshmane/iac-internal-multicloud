# GCP Cloud DNS Managed Zones Terraform Module

Production-ready Terraform module for provisioning Google Cloud Managed DNS Zones (Private VPC split-horizon or Public internet domains) and automated DNS record sets (A, AAAA, CNAME, TXT, MX).

## Features
- **Private & Public Zones**: Support for internal VPC private resolution and public internet domain zones.
- **VPC Binding**: Multi-VPC network association for private split-horizon resolution.
- **Dynamic Record Sets**: Manage A, CNAME, TXT, MX, and AAAA records declaratively.

## Usage Example

```hcl
module "private_dns" {
  source = "./modules/cloud-dns"

  zone_name   = "internal-app-zone"
  project_id  = "my-gcp-project-123456"
  dns_name    = "corp.internal."
  visibility  = "private"
  description = "Private VPC internal DNS resolution zone"

  private_visibility_networks = [
    "projects/my-gcp-project-123456/global/networks/prod-vpc-network"
  ]

  recordsets = [
    {
      name    = "api"
      type    = "A"
      ttl     = 300
      records = ["10.100.0.10"]
    },
    {
      name    = "db"
      type    = "CNAME"
      ttl     = 300
      records = ["postgres.corp.internal."]
    }
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
