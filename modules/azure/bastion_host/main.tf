# Azure Bastion Host Module
# Deploys an Azure Bastion Host in a dedicated AzureBastionSubnet with Standard or Basic SKU, IP configuration, and tunneling options.

resource "azurerm_bastion_host" "this" {
  name                   = var.bastion_host_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  sku                    = var.sku
  scale_units            = var.sku == "Standard" ? var.scale_units : 2
  copy_paste_enabled     = var.copy_paste_enabled
  file_copy_enabled      = var.sku == "Standard" ? var.file_copy_enabled : null
  tunneling_enabled      = var.sku == "Standard" ? var.tunneling_enabled : null
  shareable_link_enabled = var.sku == "Standard" ? var.shareable_link_enabled : null

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = var.azure_bastion_subnet_id
    public_ip_address_id = var.public_ip_id
  }

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}
