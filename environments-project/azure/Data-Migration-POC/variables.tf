# ---------------------------------------------------------------------------------------------------------------------
# CORE IDENTIFIERS & GENERAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "subscription_id" {
  description = "The Azure Subscription ID (optional if set via environment variable ARM_SUBSCRIPTION_ID or Azure CLI)."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group to create."
  type        = string
  default     = "Data-Migration-POC"
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name tag."
  type        = string
  default     = "Data-Migration-POC"
}

# ---------------------------------------------------------------------------------------------------------------------
# MANDATORY TAGS (MATCHING REFERENCE RESOURCE GROUP rg-ai-dev-eus2-001)
# ---------------------------------------------------------------------------------------------------------------------

variable "tag_requested_by" {
  description = "Requested By / Requester tag value."
  type        = string
  default     = "Ganeswar.Pasalapudi@programmers.ai"
}

variable "tag_approved_by" {
  description = "Approved By tag value."
  type        = string
  default     = "smitesh.mane@programmers.ai"
}

variable "tag_created_by" {
  description = "CreatedBy tag value."
  type        = string
  default     = "Yogesh.pathe@programmers.ai"
}

variable "tag_managed_by" {
  description = "ManagedBy tag value."
  type        = string
  default     = "IT-solutions@programmers.ai"
}

variable "tag_review_date" {
  description = "ReviewDate tag value."
  type        = string
  default     = "12/31/2026"
}

variable "extra_tags" {
  description = "Additional tags to append."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING (VIRTUAL NETWORK, SUBNETS, NSGS, ROUTE TABLES VIA FOR_EACH)
# ---------------------------------------------------------------------------------------------------------------------

variable "vnet_address_space" {
  description = "The address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create with for_each. Sized for least cost and Azure MI delegation."
  type = map(object({
    name               = string
    address_prefixes   = list(string)
    delegation_service = optional(string)
    delegation_actions = optional(list(string))
    nsg_key            = optional(string)
    route_table_key    = optional(string)
  }))
  default = {
    "sqlmi" = {
      name               = "snet-sqlmi-dev-eus2-001"
      address_prefixes   = ["10.0.1.0/26"] # /26 (64 IPs) to host multiple MIs without IP exhaustion
      delegation_service = "Microsoft.Sql/managedInstances"
      delegation_actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
      nsg_key         = "sqlmi"
      route_table_key = "sqlmi"
    }
    "source_vm" = {
      name               = "snet-sourcesql-dev-eus2-001"
      address_prefixes   = ["10.0.2.0/28"] # /28 (16 IPs) minimal subnet for source VM
      delegation_service = null
      delegation_actions = null
      nsg_key            = "source_vm"
      route_table_key    = null
    }
  }
}

variable "route_tables" {
  description = "Map of Route Tables to provision with for_each."
  type = map(object({
    name                          = string
    bgp_route_propagation_enabled = optional(bool, true)
  }))
  default = {
    "sqlmi" = {
      name                          = "rt-sqlmi-dev-eus2-001"
      bgp_route_propagation_enabled = true
    }
  }
}

variable "network_security_groups" {
  description = "Map of Network Security Groups and their rules to provision with for_each."
  type = map(object({
    name = string
    rules = list(object({
      name                         = string
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      source_port_range            = optional(string, "*")
      destination_port_range       = optional(string)
      destination_port_ranges      = optional(list(string))
      source_address_prefix        = optional(string)
      source_address_prefixes      = optional(list(string))
      destination_address_prefix   = optional(string)
      destination_address_prefixes = optional(list(string))
    }))
  }))
  default = {
    "sqlmi" = {
      name = "nsg-sqlmi-dev-eus2-001"
      rules = [
        {
          name                       = "allow_management_inbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_ranges    = ["9000", "9003", "1438", "1440", "1452"]
          source_address_prefix      = "SqlManagement"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow_misubnet_inbound"
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "10.0.1.0/26"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow_tds_inbound"
          priority                   = 300
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "1433"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow_health_probe_inbound"
          priority                   = 400
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_ranges    = ["65529", "65530"]
          source_address_prefix      = "AzureLoadBalancer"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow_management_outbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_ranges    = ["443", "12000"]
          source_address_prefix      = "*"
          destination_address_prefix = "AzureCloud"
        },
        {
          name                       = "allow_misubnet_outbound"
          priority                   = 200
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "10.0.1.0/26"
        },
        {
          name                       = "allow_storage_outbound"
          priority                   = 300
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "Storage"
        }
      ]
    }
    "source_vm" = {
      name = "nsg-sourcesql-dev-eus2-001"
      rules = [
        {
          name                   = "allow_internal_sql"
          priority               = 100
          direction              = "Inbound"
          access                 = "Allow"
          protocol               = "Tcp"
          destination_port_range = "1433"
          source_address_prefix  = "VirtualNetwork"
        },
        {
          name                   = "allow_rdp_management"
          priority               = 200
          direction              = "Inbound"
          access                 = "Allow"
          protocol               = "Tcp"
          destination_port_range = "3389"
          source_address_prefix  = "VirtualNetwork"
        }
      ]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DESTINATION: AZURE SQL MANAGED INSTANCES (FOR_EACH OVER MAP)
# ---------------------------------------------------------------------------------------------------------------------

variable "default_mi_administrator_login_password" {
  description = "Default SQL Admin password for Managed Instances (set via GitHub Secret TF_VAR_default_mi_administrator_login_password)."
  type        = string
  sensitive   = true
  default     = null
}

variable "managed_instances" {
  description = "Map of Azure SQL Managed Instances to provision on the same delegated VNet & Subnet using for_each."
  type = map(object({
    name                         = optional(string)
    subnet_key                   = optional(string, "sqlmi")
    sku_name                     = optional(string, "GP_Gen5")
    vcores                       = optional(number, 4)
    storage_size_in_gb           = optional(number, 32)
    license_type                 = optional(string, "LicenseIncluded")
    administrator_login          = optional(string, "sqladmin")
    administrator_login_password = optional(string)
    connection_type              = optional(string, "Redirect")
    public_data_endpoint_enabled = optional(bool, false)
    storage_account_type         = optional(string, "LRS")
    azuread_administrator = optional(object({
      login_username              = string
      object_id                   = string
      tenant_id                   = optional(string)
      azuread_authentication_only = optional(bool, false)
    }))
  }))
  default = {
    "primary" = {
      sku_name           = "GP_Gen5"
      vcores             = 4
      storage_size_in_gb = 32
      license_type       = "LicenseIncluded"
    }
    "secondary" = {
      sku_name           = "GP_Gen5"
      vcores             = 4
      storage_size_in_gb = 32
      license_type       = "LicenseIncluded"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MIGRATION STORAGE ACCOUNTS (FOR_EACH OVER MAP)
# ---------------------------------------------------------------------------------------------------------------------

variable "storage_accounts" {
  description = "Map of Storage Accounts and containers to create with for_each."
  type = map(object({
    name_prefix              = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    containers               = optional(list(string), ["migration-backups"])
  }))
  default = {
    "migration" = {
      name_prefix              = "stgmigpoc"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      containers               = ["migration-backups"]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SOURCE: VIRTUAL MACHINES (FOR_EACH OVER MAP)
# ---------------------------------------------------------------------------------------------------------------------

variable "default_vm_admin_password" {
  description = "Default admin password for virtual machines (set via GitHub Secret TF_VAR_default_vm_admin_password)."
  type        = string
  sensitive   = true
  default     = null
}

variable "virtual_machines" {
  description = "Map of virtual machines to provision with for_each."
  type = map(object({
    name            = string
    subnet_key      = optional(string, "source_vm")
    vm_size         = optional(string, "Standard_B2s")
    os_disk_size_gb = optional(number, 32)
    admin_username  = optional(string, "azureuser")
    admin_password  = optional(string)
    image_publisher = optional(string, "MicrosoftSQLServer")
    image_offer     = optional(string, "sql2022-ws2022")
    image_sku       = optional(string, "sqldev-gen2")
  }))
  default = {
    "source_sql" = {
      name            = "vm-sqlsource"
      subnet_key      = "source_vm"
      vm_size         = "Standard_B2s"
      os_disk_size_gb = 32
      admin_username  = "azureuser"
      image_publisher = "MicrosoftSQLServer"
      image_offer     = "sql2022-ws2022"
      image_sku       = "sqldev-gen2"
    }
  }
}
