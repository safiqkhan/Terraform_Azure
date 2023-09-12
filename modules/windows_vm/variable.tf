variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for the VM."
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine."
  type        = string
}
variable "network_interface_ids" {
  description = "network interface id of virtual machine."
  type        = list(string)
}

variable "admin_username" {
  description = "Admin username for the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machine."
  type        = string
}
