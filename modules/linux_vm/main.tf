 resource "tls_private_key" "key" {
   algorithm   = "RSA"
   rsa_bits    = 4096
 }
 resource "local_file" "azurekey" {
   filename = "azurekey.pem"
   content = tls_private_key.key.private_key_pem
 }
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.network_interface_ids
  # size                  = "Standard_B1s"
  size                  = "Standard_F4s"
  admin_username = var.admin_username
  // custom_data = filebase64("customdata.sh")
  # review cloud-init logs at /var/log/cloud-init.log
  admin_ssh_key {
     username   = var.admin_username
     public_key = tls_private_key.key.public_key_openssh
  }
  // admin_ssh_key {
  //   username   = var.admin_username
  //   public_key = file("azurekey.pub")
  // }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [ tls_private_key.key ]
  # source_image_reference {
  #   publisher = "RedHat"
  #   offer     = "RHEL"
  #   sku       = "8-lvm-gen2"
  #   version   = "latest"
  # }
   provisioner "file" {
    source      = "customdata.sh"    # Local path to your script
    destination = "/tmp/script.sh"  # Destination path on the VM
  }
   provisioner "remote-exec" {
     inline = [
       "chmod +x /tmp/customdata.sh",
       "/tmp/customdata.sh > /tmp/log.txt 2>&1",  # Run the script and capture output in log
     ]
   }
   connection {
     type        = "ssh"
     host        = self.public_ip_address
     user        = var.admin_username
     private_key = tls_private_key.key.private_key_pem
   }
}
