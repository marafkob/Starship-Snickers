resource "azurerm_resource_group" "myresourcegroup" {
  name     = "arveds_resourcegroup"
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
  name                = "arveds-network"
  location            = azurerm_resource_group.myresourcegroup.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "arveds-subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "arveds-subnet2"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.nsgexample.id
  }

  tags = {
    environment = "Production"
  }
}