variable "resource_group_name" {
  description = "The name of the resource group."
  default = "Automated_Test"
}

variable "location" {
  description = "The location for the virtual machine."
  default = "koreacentral"
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  default = "Tester"
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  default = "Tester1234$"
}

variable "vm_name" {
  description = "The name of the virtual machine."
  default     = "azurecliVM"
}

variable "vm_size" {
  description = "The size of the virtual machine."
  default     = "Standard_DS2_v2"
}

variable "publisher" {
  description = "The publisher of the Windows image."
  default     = "MicrosoftWindowsDesktop"
}

variable "offer" {
  description = "The offer of the Windows image."
  default     = "Windows-10"
}

variable "sku" {
  description = "The SKU of the Windows image."
  default     = "20h2-evd"
}

variable "version" {
  description = "The version of the Windows image."
  default     = "latest"
}

variable "os_disk_caching" {
  description = "The caching option for the OS disk."
  default     = "ReadWrite"
}

variable "os_disk_storage_type" {
  description = "The storage account type for the OS disk."
  default     = "Premium_LRS"
}