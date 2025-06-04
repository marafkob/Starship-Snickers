resource "azurerm_resource_group" "Bill" {
  name     = "Bill"
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
  name                = "Bill-network"
  location            = azurerm_resource_group.Bill.location
  resource_group_name = azurerm_resource_group.Bill.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "subnet2"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.Bill_netsecgroup.id
  }
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