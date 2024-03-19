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
    resource_group_name  = "resource_group_name"
    storage_account_name = "statefile25"
    container_name       = "statefile"
    key                  = "terraform.tfstate"
  }
}

# definiert einen Provider für Terraform, speziell den "azurerm"-Provider, der verwendet wird, um mit Azure-Ressourcen zu 
# interagieren und sie zu verwalten.
provider "azurerm" {
  subscription_id = "azure_subscription_id"
  tenant_id       = "tanant_id"
  features {}
}
