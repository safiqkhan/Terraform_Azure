resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.network_interface_ids
  #size = "Standard_DS1_v2"
  size = "Standard_B1s"

# get from - az vm image list --offer windowsserver --output table
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  os_disk {
    name              = "test-Disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}
