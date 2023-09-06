data "azurerm_network_security_group" "ubuntu" {
  name                = "test-nsg"
  resource_group_name = var.resource_group_name
}


resource "azurerm_network_interface_security_group_association" "ubuntu" {
  count                      = var.subnet_count
  network_interface_id = azurerm_network_interface.ubuntu[count.index].id
  network_security_group_id = data.azurerm_network_security_group.ubuntu.id
}

# Azure portal 
resource "azurerm_public_ip" "ubuntu" {
  count               = var.subnet_count
  name                = "publicip-${random_integer.ubuntu[count.index].result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

# subnet_result.json 파일을 읽어와서 Terraform 변수로 할당
data "local_file" "subnet_result" {
  filename = "subnet_result.json"
}
locals {
  subnet_result = jsondecode(data.local_file.subnet_result.content)
}
resource "azurerm_subnet" "ubuntu" {
  count                = var.subnet_count
  name                 = "subnet-${random_integer.ubuntu[count.index].result}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ubuntu.name
  address_prefixes     = [local.subnet_result.subnet]
#  address_prefixes     = [local.subnet_result] # PowerShell 스크립트 결과를 사용
#  address_prefixes     = [cidrsubnet(azurerm_virtual_network.ubuntu.address_space[0], 8, count.index)]
}

resource "azurerm_network_interface" "ubuntu" {
  count                = var.subnet_count
  name                 = "nic-${random_integer.ubuntu[count.index].result}"
  resource_group_name  = var.resource_group_name
  location             = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ubuntu[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.ubuntu[count.index].id
  }

  tags = {
    environment = "test"
  }
}

resource "random_integer" "ubuntu" {
  count = var.subnet_count
  min   = 1000
  max   = 9999
}

resource "azurerm_virtual_network" "ubuntu" {
  name                = "vnet-ubuntu"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_linux_virtual_machine" "ubuntu" {
  count                = var.subnet_count
  name                 = "vm-${random_integer.ubuntu[count.index].result}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  size                 = var.vm_size
  admin_username       = var.admin_username
  disable_password_authentication = true
  ssh_key {
    key_data = file("~/.ssh/id_rsa.pub") # SSH 공개 키 경로
  }
  network_interface_ids = [azurerm_network_interface.default[count.index].id]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = "20.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}