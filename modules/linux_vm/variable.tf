variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "Test-rg"
}
variable "location" {
  description = "Azure region for the VM."
  type        = string
  default     = "East US"
}
variable "vm_name" {
  description = "Name of the virtual machine."
  type        = string
  default     = "linux-vm"
}
variable "network_interface_ids" {
  description = "network interface id of virtual machine."
  type        = list(string)
}

variable "admin_username" {
  description = "Admin username for the virtual machine."
  type        = string
  default     = "Adminuser"
}
