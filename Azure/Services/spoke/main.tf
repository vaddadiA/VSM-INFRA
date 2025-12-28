terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.87.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.40.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_subscription_id
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}