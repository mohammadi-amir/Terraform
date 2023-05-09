#Variabelen
locals {
  Ressource_Group_Name     = "amir-rg"
  Ressource_Group_Location = "West Europe"
}

# Resource Grpoup Erstellen
resource "azurerm_resource_group" "rg-amir" {
  name     = local.Ressource_Group_Name
  location = local.Ressource_Group_Location
}
# Public IP Erstellen
resource "azurerm_public_ip" "Public-ip" {
  name                = "Public-ip"
  resource_group_name = local.Ressource_Group_Name
  location            = local.Ressource_Group_Location
  allocation_method   = "Static"

}
# Vertual Network Erstellen
resource "azurerm_virtual_network" "amir-vnet" {
  name                = "amir-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = local.Ressource_Group_Location
  resource_group_name = local.Ressource_Group_Name
}
#sshkey Erstellen
Erstellen
}
#Subnet Erstellen 
resource "azurerm_subnet" "amir-subnet" {
  name                 = "amir-subnet"
  resource_group_name  = local.Ressource_Group_Name
  virtual_network_name = azurerm_virtual_network.amir-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Network interface Erstellen
resource "azurerm_network_interface" "amir-nic" {
  name                = "amir-nic"
  location            = local.Ressource_Group_Location
  resource_group_name = local.Ressource_Group_Name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.amir-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Public-ip.id
  }
}

#Network Security Group 
resource "azurerm_network_security_group" "amir-nsg" {
  name                = "amir-nsg"
  location            = local.Ressource_Group_Location
  resource_group_name = local.Ressource_Group_Name

  #Security Ruls difinieren
  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "all_out"
    priority                   = 400
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



# Verbinden NSG1 mit NIC1 
resource "azurerm_network_interface_security_group_association" "Sec-association" {
  network_interface_id      = azurerm_network_interface.amir-nic.id
  network_security_group_id = azurerm_network_security_group.amir-nsg.id
}

#VM Erstellen
resource "azurerm_linux_virtual_machine" "amir-vm" {
  name                = "service"
  resource_group_name = local.Ressource_Group_Name
  location            = local.Ressource_Group_Location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
  azurerm_network_interface.amir-nic.id, ]

  #sshkey erstellen
  admin_ssh_key {
    username   = "azureuser"
    public_key = azurerm_ssh_public_key.sshkey.public_key
  }

# Eigenschaften der Betriebssystemfestplatte (OS Disk)
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
# Mit diesen Eigenschaften wird Terraform das entsprechende Image identifizieren und für die Bereitstellung der Ressource verwenden
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

}
