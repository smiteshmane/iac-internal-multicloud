# Azure Virtual Machine Scale Set (VMSS) Module
# Provisions a Linux Virtual Machine Scale Set with load balancer integration and autoscale settings.

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                            = var.vmss_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku                             = var.sku
  instances                       = var.instances
  admin_username                  = var.admin_username
  admin_password                  = var.disable_password_authentication ? null : var.admin_password
  disable_password_authentication = var.disable_password_authentication

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_key != null ? [var.ssh_public_key] : []
    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = var.load_balancer_backend_address_pool_ids
    }
  }

  identity {
    type = var.identity_type
  }

  tags = merge(
    {
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}
