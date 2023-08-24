# Windows 가상 머신 생성
resource "azurerm_windows_virtual_machine" "example" {
  name                = "azurecliVM"
  resource_group_name = "Automated_Test"
  location            = "koreacentral"
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

  admin_username = "adminuser"
  admin_password = "Password1234!"  # 반드시 안전한 암호를 사용하세요.
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}