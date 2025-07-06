# main.tf

# Use Azure provider
provider "azurerm" {
  features {}
  subscription_id = "a8715d58-743d-4b54-b671-230ce91aab9b"
}

# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "hygiene-rg"
  location = "East US"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "hygiene-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "hygiene-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "vm_ip" {
  name                = "hygiene-vm-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   # changed from Dynamic to Static
  sku                 = "Standard" # required to be set with Static
}

# Create NIC
resource "azurerm_network_interface" "nic" {
  name                = "hygiene-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }
}

# Create Ubuntu 22.04 VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "hygiene-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "puneet"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "puneet"
    public_key = file("~/.ssh/id_rsa.pub")  # Change this if your key is different
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  disable_password_authentication = true
}

# 🔐 Create NSG with rule to allow SSH
resource "azurerm_network_security_group" "nsg" {
  name                = "hygiene-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Add more rules here later (HTTP, HTTPS, etc.)
}
resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
