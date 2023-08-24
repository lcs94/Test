resource "azurerm_windows_virtual_machine" "example" {
  name                = "azurecliVM"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_DS2_v2"

  network_interface_ids = [
    "/subscriptions/f85dce05-6791-4464-afde-6ac8649b9b3d/resourceGroups/Automated_Test/providers/Microsoft.Network/networkInterfaces/Automated_Test",
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h2-evd"
    version   = "latest"
  }

  admin_username = var.admin_username
  admin_password = var.admin_password
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
