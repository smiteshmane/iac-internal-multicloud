# Azure Kubernetes Service (AKS) Terraform Module

This module provisions a production-ready Azure Kubernetes Service (AKS) cluster with Azure CNI networking, Workload Identity (OIDC), Container Insights monitoring, and additional user node pools.

## Usage Example

```hcl
module "aks" {
  source                      = "../../modules/aks"
  cluster_name                = "aks-core-prod-001"
  location                    = "eastus"
  resource_group_name         = "rg-aks-prod"
  dns_prefix                  = "aksprod"
  vnet_subnet_id              = module.app_subnet.subnet_id
  log_analytics_workspace_id  = module.log_analytics.workspace_id
  environment                 = "prod"

  default_node_pool = {
    name                = "system"
    vm_size             = "Standard_D4s_v5"
    node_count          = 3
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 10
  }

  additional_node_pools = {
    "userpool" = {
      vm_size             = "Standard_E4s_v5"
      node_count          = 2
      enable_auto_scaling = true
      min_count           = 2
      max_count           = 8
      mode                = "User"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_name` | Name of the AKS Cluster | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `dns_prefix` | DNS prefix | `string` | n/a | yes |
| `vnet_subnet_id` | Subnet ID for nodes | `string` | `null` | no |
| `log_analytics_workspace_id` | Log Analytics ID | `string` | `null` | no |
| `default_node_pool` | System node pool config | `object` | `{}` | no |
| `additional_node_pools` | Extra user node pools | `map` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `aks_id` | Resource ID of the AKS cluster |
| `aks_name` | Name of the AKS cluster |
| `kube_config_raw` | Raw kubectl config (sensitive) |
| `oidc_issuer_url` | OIDC Issuer URL for Workload Identity |
| `principal_id` | Managed Identity Principal ID |
