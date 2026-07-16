terraform {
  required_version = "= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.80"
    }
  }
}

provider "azurerm" {
  features {}
}

module "storage_container" {
  source = "../.."

  name                  = "tfstate"
  storage_account_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-platform-001/providers/Microsoft.Storage/storageAccounts/stplatformexample001"
  container_access_type = "private"
}

output "storage_container_id" {
  description = "Storage container ID."
  value       = module.storage_container.id
}

output "storage_container_name" {
  description = "Storage container name."
  value       = module.storage_container.name
}
