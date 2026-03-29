terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.65.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = "e73bef49-aa62-4364-b4ff-6f1aaf7b471b"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "arg" {
  name     = "ContactsBookRG-${random_integer.ri.result}"
  location = "Poland Central"
}

resource "azurerm_service_plan" "asp" {
  name                = "contact-book-${random_integer.ri.result}"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "alwa" {
  name                = "contact-book-${random_integer.ri.result}"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      node_version = "20-lts"
    }
    always_on = false
  }
}

resource "azurerm_app_service_source_control" "aassc" {
  app_id                 = azurerm_linux_web_app.alwa.id
  branch                 = "master"
  repo_url               = "https://github.com/nakov/ContactBook"
  use_manual_integration = true
}