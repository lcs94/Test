data "azurerm_network_security_group" "default" {
  name                = "test-nsg"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "winrm_inbound" {
  name                        = "winrm-inbound"
  resource_group_name         = var.resource_group_name
  location                    = var.location
}

resource "azurerm_network_security_rule" "winrm_inbound" {
  name                        = "winrm-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.winrm_inbound.name
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5985" # WinRM 포트
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_group" "winrm_inbound_https" {
  name                        = "winrm-inbound-https"
  resource_group_name         = var.resource_group_name
  location                    = var.location
}

resource "azurerm_network_security_rule" "winrm_inbound_https" {
  name                        = "winrm-inbound-https"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.winrm_inbound_https.name
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5986" # WinRM HTTPS 포트
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface_security_group_association" "default" {
  count                      = var.subnet_count
  network_interface_id = azurerm_network_interface.default[count.index].id
  network_security_group_id = data.azurerm_network_security_group.default.id
}

# Azure portal 
resource "azurerm_public_ip" "default" {
  count               = var.subnet_count
  name                = "publicip-${random_integer.default[count.index].result}"
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
  admin_username = var.admin_username
  admin_password = var.admin_password
  user_data                       = base64encode("Hello World!")

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

  provisioner "file" {
    source      = "${path.module}/file/java.ps1"
    destination = "C:\\Temp\\java.ps1"

    connection {
      type     = "winrm"
      user     = "var.admin_username"
      password = "var.admin_password"
      host     = azurerm_windows_virtual_machine.default[count.index].private_ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -ExecutionPolicy Bypass C:\\Temp\\java.ps1"
    ]
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}