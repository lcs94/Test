variable "resource_group_name" {
  description = "The name of the resource group."
  default     = "Automated_Test"
  type        = string
}

variable "location" {
  description = "The location for the virtual machine."
  default     = "koreacentral"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  default     = "Tester"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  default     = "Tester1234$"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine."
  default     = "azurecliVM"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  default     = "Standard_DS2_v2"
  type        = string
}

variable "publisher" {
  description = "The publisher of the Windows image."
  default     = "MicrosoftWindowsDesktop"
  type        = string
}

variable "offer" {
  description = "The offer of the Windows image."
  default     = "Windows-10"
  type        = string
}

variable "sku" {
  description = "The SKU of the Windows image."
  default     = "20h2-evd"
  type        = string
}

variable "windows_version" {
  description = "The version of the Windows image."
  default     = "latest"
  type        = string
}

variable "os_disk_caching" {
  description = "The caching option for the OS disk."
  default     = "ReadWrite"
  type        = string
}

variable "os_disk_storage_type" {
  description = "The storage account type for the OS disk."
  default     = "Premium_LRS"
  type        = string
}

variable "subnet_count" {
  description = "Number of subnets to create"
  default     = 1
}

variable "subnet_result" {
  type = string
  description = "Subnet result from PowerShell script"
  default = "10.0.0.0/24" # 기본값 설정
}

variable "variables_result" {
  description = "JSON data from PowerShell script"
  type        = string
}
