resource "azurerm_windows_virtual_machine" "VM" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  network_interface_ids = [
    "/subscriptions/f85dce05-6791-4464-afde-6ac8649b9b3d/resourceGroups/Automated_Test/providers/Microsoft.Network/networkInterfaces/Automated_Test",
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.windows_version
  }

  admin_username = var.admin_username
  admin_password = var.admin_password
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
