# Azure Cache for Redis Terraform Module

This module provisions an Azure Cache for Redis instance (Basic, Standard, or Premium SKU) with minimum TLS 1.2 enforcement, non-SSL port disabled by default, and optional firewall rules.

## Usage Example

```hcl
module "redis" {
  source              = "../../modules/redis_cache"
  redis_name          = "redis-cache-prod-001"
  location            = "eastus"
  resource_group_name = "rg-cache-prod"
  sku_name            = "Standard"
  family              = "C"
  capacity            = 2
  maxmemory_policy    = "allkeys-lru"
  environment         = "prod"

  firewall_rules = {
    "AllowAppSubnet" = {
      start_ip = "10.0.1.0"
      end_ip   = "10.0.1.255"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `redis_name` | Name of Redis Cache | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource Group name | `string` | n/a | yes |
| `sku_name` | Basic, Standard, Premium | `string` | `"Standard"` | no |
| `family` | C or P | `string` | `"C"` | no |
| `capacity` | Capacity size (0-6) | `number` | `1` | no |
| `enable_non_ssl_port` | Allow port 6379 | `bool` | `false` | no |
| `firewall_rules` | Firewall rules map | `map` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `redis_id` | Resource ID of Redis Cache |
| `redis_hostname` | FQDN Hostname |
| `redis_ssl_port` | SSL Port (6380) |
| `primary_access_key` | Primary key (sensitive) |
| `primary_connection_string` | Connection string (sensitive) |
