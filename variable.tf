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
  default     = "test-vm"
}
variable "admin_password" {
  description = "Admin password for the virtual machine."
  type        = string
  sensitive   = false
  default     = "Safiq$9078"
}
variable "storage_account_name" {
  description = "Name of the storage account name."
  type        = string
  default     = "safiqstoracc"
}
variable "ARM_ACCESS_KEY" {
  description = "Name of the storage account name."
  type        = string
  default     = " "
}