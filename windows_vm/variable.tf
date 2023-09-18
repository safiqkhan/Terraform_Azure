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
variable "admin_password" {
  description = "Admin password for the virtual machine."
  type        = string
  sensitive   = false
  default     = "Safiq$9078"
}
