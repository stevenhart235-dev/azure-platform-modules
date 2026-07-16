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

  name                = "stsharedexample001"
  resource_group_name = "rg-example-shared-services-001"
  location            = "centralus"

  account_tier                   = "Standard"
  account_replication_type       = "ZRS"
  hierarchical_namespace_enabled = true
  public_network_access_enabled  = true

  # Documentation-only placeholder from TEST-NET-3.
  # Real bootstrap deployments must supply the current runner/developer
  # public egress IP range or an approved subnet ID.
  network_ip_rules = ["203.0.113.10"]

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

output "storage_account_id" {
  description = "Storage account ID."
  value       = module.storage_account.id
}

output "storage_account_name" {
  description = "Storage account name."
  value       = module.storage_account.name
}

output "storage_account_resource_group_name" {
  description = "Storage account resource group name."
  value       = module.storage_account.resource_group_name
}

output "storage_account_location" {
  description = "Storage account location."
  value       = module.storage_account.location
}

output "primary_blob_endpoint" {
  description = "Primary Blob service endpoint."
  value       = module.storage_account.primary_blob_endpoint
}

output "storage_account_tags" {
  description = "Tags applied to the storage account."
  value       = module.storage_account.tags
}
