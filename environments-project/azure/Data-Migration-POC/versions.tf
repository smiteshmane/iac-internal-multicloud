terraform {
  required_version = ">= 1.5.0"

  # Remote State Backend in Azure Blob Storage
  backend "azurerm" {
    resource_group_name  = "Data-Migration-POC"
    storage_account_name = "datamigpoc8"
    container_name       = "tfstate"
    key                  = "data-migration-poc.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id != "" ? var.subscription_id : null
}
