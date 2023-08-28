resource "azurerm_public_ip" "default" {
  count               = var.subnet_count
  name                = "publicip-${random_integer.default[count.index].result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

# subnet_result.json 파일을 읽어와서 Terraform 변수로 할당하고 개행 문자 제거
data "local_file" "subnet_result" {
  filename = "subnet_result.json"
}
locals {
  subnet_result = jsondecode(data.local_file.subnet_result.content)
}
resource "azurerm_subnet" "default" {
  count                = var.subnet_count
  name                 = "subnet-${random_integer.default[count.index].result}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = [local.subnet_result.subnet]
#  address_prefixes     = [local.subnet_result] # PowerShell 스크립트 결과를 사용
#  address_prefixes     = [cidrsubnet(azurerm_virtual_network.default.address_space[0], 8, count.index)]
}

resource "azurerm_network_interface" "default" {
  count                = var.subnet_count
  name                 = "nic-${random_integer.default[count.index].result}"
  resource_group_name  = var.resource_group_name
  location             = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.default[count.index].id
  }

  tags = {
    environment = "test"
  }
}

resource "random_integer" "default" {
  count = var.subnet_count
  min   = 1000
  max   = 9999
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-default"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_windows_virtual_machine" "default" {
  count                = var.subnet_count
  name                 = "vm-${random_integer.default[count.index].result}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  size                 = var.vm_size

  network_interface_ids = [azurerm_network_interface.default[count.index].id]

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
