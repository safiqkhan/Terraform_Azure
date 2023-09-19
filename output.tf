output "windows_vm_name" {
  value = module.windows_vm.vm_name
}
output "windows_admin_username" {
  value = module.windows_vm.admin_username
}
output "windows_vm_private_ip" {
  value = module.windows_vm.private_ip
}
output "windows_vm_public_ip" {
  value = module.windows_vm.public_ip
}
output "windows_vm_password" {
  sensitive = true
  value = module.windows_vm.admin_password
}
output "linux_vm_name" {
  value = module.linux_vm.vm_name
}
output "linux_admin_username" {
  value = module.linux_vm.admin_username
}
output "linux_vm_private_ip" {
  value = module.linux_vm.private_ip
}
output "linux_public_ip_address" {
  value = module.linux_vm.public_ip
}
