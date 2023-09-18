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