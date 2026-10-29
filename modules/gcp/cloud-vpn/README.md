# GCP HA Cloud VPN Gateway & BGP Terraform Module

Production-ready Terraform module for provisioning High Availability (HA) Cloud VPN Gateways with dynamic BGP Cloud Router integration, IPsec tunnels, and IKEv2 pre-shared keys for hybrid cloud / on-premise datacenter or AWS/Azure connectivity.

## Features
- **High Availability**: Dual-interface HA VPN gateway configuration meeting 99.99% SLA.
- **BGP Dynamic Routing**: Automated BGP Cloud Router route exchange.
- **IPsec Tunnels**: Encrypted IPsec tunnels for secure cross-cloud data transfer.

## Usage Example

```hcl
module "hybrid_vpn" {
  source = "./modules/cloud-vpn"

  name       = "prod-onprem-vpn"
  project_id = "my-gcp-project-123456"
  region     = "us-central1"
  network    = "projects/my-gcp-project-123456/global/networks/prod-vpc-network"
  bgp_asn    = 65000

  tunnels = [
    {
      name                  = "onprem-tunnel-0"
      peer_external_ip      = "203.0.113.10"
      shared_secret         = "secret-key-12345"
      vpn_gateway_interface = 0
    },
    {
      name                  = "onprem-tunnel-1"
      peer_external_ip      = "203.0.113.11"
      shared_secret         = "secret-key-12345"
      vpn_gateway_interface = 1
    }
  ]
}
```
