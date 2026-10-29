# Azure Load Balancer Terraform Module

This module provisions an Azure Load Balancer (Public or Internal) with frontend IP configuration, backend address pool, health probes, and load balancing rules.

## Usage Example

```hcl
module "lb" {
  source               = "../../modules/load_balancer"
  lb_name              = "lbr-app-prod-001"
  location             = "eastus"
  resource_group_name  = "rg-network-prod"
  public_ip_address_id = module.pip.public_ip_id
  environment          = "prod"

  probes = [
    {
      name         = "http-health-probe"
      port         = 80
      protocol     = "Http"
      request_path = "/health"
    }
  ]

  lb_rules = [
    {
      name          = "http-rule"
      protocol      = "Tcp"
      frontend_port = 80
      backend_port  = 80
      probe_name    = "http-health-probe"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `lb_name` | Load Balancer name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `sku` | Basic or Standard | `string` | `"Standard"` | no |
| `frontend_ip_name` | Frontend IP config name | `string` | `"LoadBalancerFrontend"` | no |
| `public_ip_address_id` | Public IP ID (for Public LB) | `string` | `null` | no |
| `subnet_id` | Subnet ID (for Internal LB) | `string` | `null` | no |
| `private_ip_address` | Static Private IP | `string` | `null` | no |
| `backend_pool_name` | Backend pool name | `string` | `"BackendAddressPool"` | no |
| `probes` | Health probes definitions | `list(object)` | `[]` | no |
| `lb_rules` | Load balancer rules definitions | `list(object)` | `[]` | no |
| `environment` | Environment name | `string` | `"dev"` | no |
| `tags` | Map of tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `lb_id` | Resource ID of Load Balancer |
| `lb_frontend_ip_config` | Frontend IP configuration block |
| `backend_address_pool_id` | ID of the Backend Address Pool |
