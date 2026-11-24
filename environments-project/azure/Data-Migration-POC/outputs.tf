# =====================================================================================================================
# OUTPUTS - AUTOMATED DATA MIGRATION PLATFORM DETAILS
# =====================================================================================================================

# ---------------------------------------------------------------------------------------------------------------------
# RESOURCE GROUP DETAILS (ACTIVE FOR INITIAL TESTING)
# ---------------------------------------------------------------------------------------------------------------------

output "resource_group_name" {
  description = "The Resource Group name containing the resources."
  value       = azurerm_resource_group.rg.name
}

output "azure_region" {
  description = "Azure region of deployment."
  value       = azurerm_resource_group.rg.location
}

output "applied_tags" {
  description = "All tags applied to the Resource Group."
  value       = local.common_tags
}

# ---------------------------------------------------------------------------------------------------------------------
# VIRTUAL NETWORK DETAILS (ACTIVE)
# ---------------------------------------------------------------------------------------------------------------------

output "virtual_network_name" {
  description = "Name of the Virtual Network."
  value       = module.virtual_network.vnet_name
}

output "virtual_network_id" {
  description = "Resource ID of the Virtual Network."
  value       = module.virtual_network.vnet_id
}

output "managed_instances" {
  description = "Map of all Azure SQL Managed Instances created in the subnet with their IDs, names, and FQDNs."
  value = {
    for k, mi in module.sql_managed_instance : k => {
      id           = mi.managed_instance_id
      name         = mi.managed_instance_name
      fqdn         = mi.fqdn
      principal_id = mi.principal_id
    }
  }
}

output "primary_managed_instance_name" {
  description = "Name of the primary Azure SQL Managed Instance."
  value       = try(module.sql_managed_instance["primary"].managed_instance_name, null)
}

output "primary_managed_instance_fqdn" {
  description = "FQDN of the primary Azure SQL Managed Instance."
  value       = try(module.sql_managed_instance["primary"].fqdn, null)
}

output "storage_accounts" {
  description = "Map of storage accounts and their primary blob endpoints created with for_each."
  value = {
    for k, stg in module.storage_accounts : k => {
      name                  = stg.storage_account_name
      primary_blob_endpoint = stg.primary_blob_endpoint
    }
  }
}

output "subnets" {
  description = "Map of subnets created with for_each."
  value = {
    for k, s in azurerm_subnet.subnets : k => {
      id               = s.id
      name             = s.name
      address_prefixes = s.address_prefixes
    }
  }
}

output "route_tables" {
  description = "Map of Route Tables created with for_each."
  value = {
    for k, rt in azurerm_route_table.route_tables : k => {
      id   = rt.id
      name = rt.name
    }
  }
}

output "network_security_groups" {
  description = "Map of Network Security Groups created with for_each."
  value = {
    for k, nsg in azurerm_network_security_group.nsgs : k => {
      id   = nsg.id
      name = nsg.name
    }
  }
}

output "mi_identities" {
  description = "Principal IDs for System-Assigned Managed Identities of the Managed Instances."
  value       = { for k, mi in module.sql_managed_instance : k => mi.principal_id }
}

output "virtual_machines" {
  description = "Map of virtual machines and their private IPs created with for_each."
  value = {
    for k, vm in azurerm_windows_virtual_machine.vms : k => {
      name       = vm.name
      private_ip = azurerm_network_interface.vm_nics[k].private_ip_address
    }
  }
}
