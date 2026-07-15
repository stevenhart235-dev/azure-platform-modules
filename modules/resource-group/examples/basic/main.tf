terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../.."

  name     = "rg-example-platform-001"
  location = "placeholder-region"

  tags = {
    managed_by = "terraform"
    purpose    = "example"
  }
}

output "resource_group_id" {
  description = "Resource group ID."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Resource group name."
  value       = module.resource_group.name
}

output "resource_group_location" {
  description = "Resource group location."
  value       = module.resource_group.location
}
