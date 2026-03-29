terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.65.0"
    }
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = "e73bef49-aa62-4364-b4ff-6f1aaf7b471b"
}

resource "azurerm_resource_group" "arg" {
  name     = "Terraform-Resource-Group"
  location = "Poland Central"
}