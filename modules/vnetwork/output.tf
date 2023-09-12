output "subnet_id" {
  description = "id of the network subnet"
  value       = azurerm_subnet.private.id
}
output "nic_id" {
  description = "id of the network interface"
  value       = azurerm_network_interface.nic.id
}
