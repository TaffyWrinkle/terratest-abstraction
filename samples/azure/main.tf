##
# Providers
##
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  features {}
}


##
# Variables
##
variable "resource_group_name" {
  type        = string
  default     = "MyTestResourceGroup"
  description = "Name of resource group to create"
}

variable "resource_group_location" {
  type        = string
  default     = "Central US"
  description = "Name of resource group to create"
}


##
# Resources
##
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_network_security_group" "nsg" {
  name                = "MyTestResourceNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "MyTestSubnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "MyTestSubnet2"
    address_prefix = "10.0.3.0/24"
    security_group = azurerm_network_security_group.nsg.id
  }

  tags = {
    environment = "production"
  }
}


##
# Outputs
##
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}