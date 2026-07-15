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

  name     = "rg-example-shared-services-001"
  location = "placeholder-region"

  tags = {
    business_unit       = "placeholder-business-unit"
    cost_center         = "placeholder-cost-center"
    criticality         = "placeholder-criticality"
    data_classification = "placeholder-data-classification"
    environment         = "placeholder-environment"
    lifecycle           = "placeholder-lifecycle"
    managed_by          = "terraform"
    owner               = "placeholder-owner-group"
    support_contact     = "placeholder-support-group"
    workload            = "placeholder-workload"
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

output "resource_group_tags" {
  description = "Tags applied to the resource group."
  value       = module.resource_group.tags
}
