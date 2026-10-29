# GCP Global HTTP(S) Load Balancer & Cloud Armor WAF Terraform Module

Production-ready Terraform module for provisioning Google Cloud Global HTTP(S) External Load Balancers with Cloud Armor Web Application Firewall (WAF) integration, health checks, SSL proxies, and global IP reservation.

## Features
- **Global Load Balancing**: Anycast external IPv4 address routing traffic to global backends.
- **Cloud Armor WAF**: DDoS protection and IP blacklist/whitelist rules via Cloud Armor Security Policies.
- **Health Checks**: Dynamic HTTP health checking for backend service health validation.
- **SSL Support**: Automatic HTTP or HTTPS proxy selection based on SSL certificate configuration.

## Usage Example

```hcl
module "lb" {
  source = "./modules/load-balancer"

  name       = "prod-web-lb"
  project_id = "my-gcp-project-123456"

  health_check_port         = 8080
  health_check_request_path = "/health"

  enable_cloud_armor = true
  blocked_ip_ranges  = ["198.51.100.0/24"]
}
```
