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