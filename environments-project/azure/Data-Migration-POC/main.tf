# =====================================================================================================================
# DATA MIGRATION POC ENVIRONMENT - SOURCE TO AZURE SQL MANAGED INSTANCES (FOR_EACH DRIVEN)
# =====================================================================================================================

locals {
  common_tags = merge(
    {
      "Requested By" = var.tag_requested_by
      "Requester"    = var.tag_requested_by
      "Approved By"  = var.tag_approved_by
      "CreatedBy"    = var.tag_created_by
      "ManagedBy"    = var.tag_managed_by
      "ReviewDate"   = var.tag_review_date
      "Environment"  = var.environment
      "Project"      = var.project_name
    },
    var.extra_tags
  )
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# RESOURCE GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# ---------------------------------------------------------------------------------------------------------------------
# VIRTUAL NETWORK (ACTIVE)
# ---------------------------------------------------------------------------------------------------------------------

module "virtual_network" {
  source              = "../../../modules/azure/virtual_network"
  vnet_name           = "vnet-${var.project_name}-eus2-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
  environment         = var.environment
  tags                = local.common_tags
}


# ---------------------------------------------------------------------------------------------------------------------
# ROUTE TABLES (FOR_EACH) & SUBNET ASSOCIATIONS
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_route_table" "route_tables" {
  for_each                      = var.route_tables
  name                          = each.value.name
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = lookup(each.value, "bgp_route_propagation_enabled", true)
  tags                          = local.common_tags
}


# ---------------------------------------------------------------------------------------------------------------------
# NETWORK SECURITY GROUPS (FOR_EACH)
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_network_security_group" "nsgs" {
  for_each            = var.network_security_groups
  name                = each.value.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

  dynamic "security_rule" {
    for_each = each.value.rules
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = lookup(security_rule.value, "source_port_range", "*")
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SUBNETS (FOR_EACH) WITH DELEGATION
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.virtual_network.vnet_name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegation_service != null ? [each.value.delegation_service] : []
    content {
      name = "delegation-${each.key}"
      service_delegation {
        name    = delegation.value
        actions = each.value.delegation_actions
      }
    }
  }
}

# Subnet to Route Table Association (for_each)
resource "azurerm_subnet_route_table_association" "rt_associations" {
  for_each = {
    for k, v in var.subnets : k => v if lookup(v, "route_table_key", null) != null
  }

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.route_tables[each.value.route_table_key].id
}

# Subnet to NSG Association (for_each)
resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = {
    for k, v in var.subnets : k => v if lookup(v, "nsg_key", null) != null
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.value.nsg_key].id
}

# ---------------------------------------------------------------------------------------------------------------------
# DESTINATION: AZURE SQL MANAGED INSTANCES (FOR_EACH ON SAME VNET & SUBNET)
# ---------------------------------------------------------------------------------------------------------------------

module "sql_managed_instance" {
  for_each = var.managed_instances
  source   = "../../../modules/azure/sql_managed_instance"

  managed_instance_name        = each.value.name != null && each.value.name != "" ? each.value.name : "sqlinst-${each.key}-${random_string.suffix.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  subnet_id                    = azurerm_subnet.subnets[coalesce(each.value.subnet_key, "sqlmi")].id
  sku_name                     = coalesce(each.value.sku_name, "GP_Gen5")
  vcores                       = coalesce(each.value.vcores, 4)
  storage_size_in_gb           = coalesce(each.value.storage_size_in_gb, 32)
  license_type                 = coalesce(each.value.license_type, "LicenseIncluded")
  administrator_login          = coalesce(each.value.administrator_login, "sqladmin")
  administrator_login_password = coalesce(each.value.administrator_login_password, var.default_mi_administrator_login_password)
  proxy_override               = coalesce(each.value.connection_type, "Redirect")
  public_data_endpoint_enabled = coalesce(each.value.public_data_endpoint_enabled, false)
  storage_account_type         = coalesce(each.value.storage_account_type, "LRS")
  environment                  = var.environment
  azuread_administrator        = each.value.azuread_administrator
  tags                         = local.common_tags

  depends_on = [
    azurerm_subnet_route_table_association.rt_associations,
    azurerm_subnet_network_security_group_association.nsg_associations
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# MIGRATION BLOB STORAGE ACCOUNTS (FOR_EACH OVER MAP)
# ---------------------------------------------------------------------------------------------------------------------

module "storage_accounts" {
  for_each = var.storage_accounts
  source   = "../../../modules/azure/storage_account"

  storage_account_name     = "${each.value.name_prefix}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = coalesce(each.value.account_tier, "Standard")
  account_replication_type = coalesce(each.value.account_replication_type, "LRS")
  environment              = var.environment
  tags                     = local.common_tags

  containers = {
    for c in each.value.containers : c => {
      container_access_type = "private"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SOURCE: VIRTUAL MACHINES & NICS (FOR_EACH OVER MAP)
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_network_interface" "vm_nics" {
  for_each            = var.virtual_machines
  name                = "${each.value.name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[coalesce(each.value.subnet_key, "source_vm")].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vms" {
  for_each            = var.virtual_machines
  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = coalesce(each.value.vm_size, "Standard_B2s")
  admin_username      = coalesce(each.value.admin_username, "azureuser")
  admin_password      = coalesce(each.value.admin_password, var.default_vm_admin_password)

  network_interface_ids = [azurerm_network_interface.vm_nics[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = coalesce(each.value.os_disk_size_gb, 32)
  }

  source_image_reference {
    publisher = coalesce(each.value.image_publisher, "MicrosoftSQLServer")
    offer     = coalesce(each.value.image_offer, "sql2022-ws2022")
    sku       = coalesce(each.value.image_sku, "sqldev-gen2")
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}
