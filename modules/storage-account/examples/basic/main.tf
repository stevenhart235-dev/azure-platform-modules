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

module "storage_account" {
  source = "../.."

  name                = "stplatformexample001"
  resource_group_name = "rg-example-platform-001"
  location            = "centralus"

  tags = {
    managed_by = "terraform"
    purpose    = "example"
  }
}

output "storage_account_id" {
  description = "Storage account ID."
  value       = module.storage_account.id
}

output "storage_account_name" {
  description = "Storage account name."
  value       = module.storage_account.name
}

output "primary_blob_endpoint" {
  description = "Primary Blob service endpoint."
  value       = module.storage_account.primary_blob_endpoint
}
