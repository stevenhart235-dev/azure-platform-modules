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

module "resource_group" {
  source = "../.."

  name     = "rg-example-platform-001"
  location = "centralus"

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
