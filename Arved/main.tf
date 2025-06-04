resource "azurerm_resource_group" "myresourcegroup" {
  name     = "arveds_resourcegroup1"
  location = "West Europe"
  tags = {
    created-by : "Arved"
  } 
}

resource "azurerm_network_security_group" "nsgexample" {
  name                = "arveds-nsg"
  location            = azurerm_resource_group.myresourcegroup.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
}

resource "azurerm_virtual_network" "myvn" {
  name                = "arveds-network1"
  location            = azurerm_resource_group.myresourcegroup.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "arveds-subnet11"
  virtual_network_name = azurerm_virtual_network.myvn.name
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "arveds-subnet12"
  virtual_network_name = azurerm_virtual_network.myvn.name
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  address_prefixes     = ["10.0.2.0/24"]
  
}

resource "azurerm_network_interface" "mynic" {
  name                = "arveds-nic"
  location            = azurerm_resource_group.myresourcegroup.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "myvm" {
  name                = "arveds-virtual-machine"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  size                = "Standard_F4"
  network_interface_ids = [azurerm_network_interface.mynic.id,]

  admin_username     = "username"
  admin_password     = "xD+123" 
  disable_password_authentication = "false"

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
}