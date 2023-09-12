# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}
# Create subnet
resource "azurerm_subnet" "private" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create public IP
resource "azurerm_public_ip" "public" {
  name                = "public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}
# Create Network Security Group and rules
resource "azurerm_network_security_group" "test_nsg" {
  name                = "test-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "test-NIC"
  resource_group_name = var.resource_group_name
  location            = var.location
  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sg-nic" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.test_nsg.id
}