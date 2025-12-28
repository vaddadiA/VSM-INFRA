terraform {
  required_version = ">= 1.3"
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = "4907c122-2bda-4f73-b2b6-e1e3e9d8a71a"
  features {}
}