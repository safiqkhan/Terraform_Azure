variable "resource_group_name" {
  type    = string
  default = "Test-rg"
}
variable "location" {
  type        = string
  default     = "East US"
}
variable "storage_account_name" {
  description = "Name of the virtual machine."
  type        = string
  default     = "safiqstoracc"
}
variable "ARM_ACCESS_KEY" {
  description = "Name of the storage account name."
  type        = string
  default     = " "
}