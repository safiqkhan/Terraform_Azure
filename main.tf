provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
module "vnetwork" {
  source              = "./modules/vnetwork"
  resource_group_name = var.resource_group_name
  location            = var.location
}
module "linux_vm" {
  source                = "./modules/linux_vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  vm_name               = "linux-vm"
  network_interface_ids = [module.vnetwork.nic_id]
  admin_username        = "Adminuser"
}
module "windows_vm" {
  source                = "./modules/windows_vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  vm_name               = "win-vm"
  network_interface_ids = [module.vnetwork.nic_id]
  admin_username        = "Adminuser"
  admin_password        = var.admin_password
}