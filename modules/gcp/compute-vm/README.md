# GCP Compute Engine VM Instance Terraform Module

Production-ready, reusable Terraform module for provisioning Google Cloud Compute Engine (GCE) Virtual Machine instances with Shielded VM security, OS Login, optional CMEK boot disk encryption, private subnetwork integration, and custom metadata.

## Features
- **Security Hardened**: Shielded VM configuration enabled by default (Secure Boot, vTPM, Integrity Monitoring).
- **Access Control**: GCP OS Login enabled by default (`enable-oslogin = "TRUE"`).
- **Network Private Security**: Public IP assignment disabled by default (`enable_public_ip = false`).
- **Encryption**: Optional Customer-Managed Encryption Key (CMEK) for boot disks.
- **Custom Startup Scripts**: Support for custom startup scripts and metadata maps.

## Usage Example

```hcl
module "dev_vm" {
  source = "./modules/compute-vm"

  instance_name = "dev-app-server"
  project_id    = "strong-province-505313-g4"
  zone          = "us-central1-a"
  machine_type  = "e2-micro"

  subnetwork       = module.vpc.subnets["us-central1/dev-vpc-network-subnet"]
  enable_public_ip = false

  boot_disk_image   = "debian-cloud/debian-12"
  boot_disk_size_gb = 20
  boot_disk_type    = "pd-standard"

  enable_shielded_vm = true
  enable_oslogin     = true

  labels = {
    environment = "development"
    managed_by  = "terraform"
    role        = "app-server"
  }
}
```
