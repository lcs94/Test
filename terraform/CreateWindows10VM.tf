resource "azurerm_subnet" "default" {
  name                 = "subnet-${random_integer.default.id}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_interface" "default" {
  name                = "default-nic-${random_integer.default.id}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "test"
  }
}

resource "random_integer" "default" {
  min = 1000
  max = 9999
}

resource "azurerm_windows_virtual_machine" "VM" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  network_interface_ids = [azurerm_network_interface.default.id]

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
