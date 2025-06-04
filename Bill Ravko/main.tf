resource "azurerm_resource_group" "Bill" {
  name     = "Bill1"
  location = "West Europe"
  tags = {
    created-by: "Bill"
  }
}

resource "azurerm_network_security_group" "Bill_netsecgroup" {
  name                = "Bill-security-group"
  location            = azurerm_resource_group.Bill.location
  resource_group_name = azurerm_resource_group.Bill.name
}

resource "azurerm_virtual_network" "Bill_vnet" {
  name                = "Bill-network1"
  location            = azurerm_resource_group.Bill.location
  resource_group_name = azurerm_resource_group.Bill.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "Bill-subnet1"
  virtual_network_name = azurerm_virtual_network.Bill_vnet.name
  resource_group_name  = azurerm_resource_group.Bill.name
  address_prefixes     = ["10.0.1.0/24"]
}
 
resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  virtual_network_name = azurerm_virtual_network.Bill_vnet.name
  resource_group_name  = azurerm_resource_group.Bill.name
  address_prefixes     = ["10.0.2.0/24"]
}
  

provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.31.0"
    }
  }
}



#VM Creation

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "Bill-vm"
  location            = azurerm_resource_group.Bill.location
  resource_group_name = azurerm_resource_group.Bill.name
  network_interface_ids = [
    azurerm_network_interface.Bill.id,
  ]
  size               = "Standard_DS2_v2"
  admin_username     = "username"
  admin_password     = "34FDA$#214f"  # For demonstration purposes only. Use secure methods for production.
  disable_password_authentication = "false"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "Bill" {
  name                = "Bill-nic"
  location            = azurerm_resource_group.Bill.location
  resource_group_name = azurerm_resource_group.Bill.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
