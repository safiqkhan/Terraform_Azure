provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  // subscription_id = var.ARM_SUBSCRIPTION_ID
  // client_id       = var.ARM_CLIENT_ID
  // client_secret   = var.ARM_CLIENT_SECRET
  // tenant_id       = var.ARM_TENANT_ID
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-RG"
  location = var.location
}
module "vnetwork" {
  source              = "./modules/vnetwork"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
module "linux_vm" {
  source                = "./modules/linux_vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  vm_name               = "linux-vm"
  network_interface_ids = [module.vnetwork.nic_id]
  admin_username        = "Adminuser"
}
module "windows_vm" {
  source                = "./modules/windows_vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  vm_name               = "win-vm"
  network_interface_ids = [module.vnetwork.nic_id]
  admin_username        = "Adminuser"
  admin_password        = var.admin_password
}
data "azurerm_resource_group" "rg-id" {
  name = "${var.resource_group_name}-rg"
}
output "resource_group_id" {
  value = data.azurerm_resource_group.rg-id.id
}

# run terraform apply --target=module.linux_vm --auto-approve
# run terraform refresh to updates Terraform's state file as per lattest changes to your infrastructure
