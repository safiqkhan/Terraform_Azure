variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "Test"
}
variable "location" {
  description = "Azure region for the VM."
  type        = string
  default     = "Central India"
}
variable "admin_password" {
  description = "Admin password for the virtual machine."
  type        = string
  sensitive   = false
  default     = "Safiq$2008"
}
