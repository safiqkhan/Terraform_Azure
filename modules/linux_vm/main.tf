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
  custom_data = filebase64("customdata.sh")
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
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install -y curl policycoreutils-python openssh-server 2>&1 /dev/null",
  #     "curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash",
  #     "public_ip=$(curl ifcfg.me 2> /dev/null)",
  #     "sudo EXTERNAL_URL=http://$public_ip yum install -y gitlab-ce",
  #     "curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash",
  #     "sudo yum install -y gitlab-runner",
  #     "sudo systemctl enable gitlab-runner",
  #   ]
  # }
  # connection {
  #   type        = "ssh"
  #   host        = self.public_ip_address
  #   user        = var.admin_username
  #   private_key = tls_private_key.key.private_key_pem
  # }
}