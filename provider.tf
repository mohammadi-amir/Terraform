#  Der Provider ermöglicht es Terraform, mit Azure-Ressourcen zu interagieren und diese zu verwalten.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.25.0"
    }
  }
  
# Diese Backend-Konfiguration sagt Terraform, dass der Azure Storage Account mit dem Namen "statefile25" 
# und dem zugehörigen Container "statefile" verwendet werden soll,
  backend "azurerm" {
    resource_group_name  = "amir-rg-statefile"
    storage_account_name = "statefile25"
    container_name       = "statefile"
    key                  = "terraform.tfstate"
  }
}

# definiert einen Provider für Terraform, speziell den "azurerm"-Provider, der verwendet wird, um mit Azure-Ressourcen zu 
# interagieren und sie zu verwalten.
provider "azurerm" {
  subscription_id = "ea6e6692-4d05-4c5b-9909-51c7dc5f5c2b"
  tenant_id       = "4dfdfd67-3a37-4e2e-b9f0-434c7061ba33"
  features {}
}
