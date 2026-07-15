terraform {
  # TODO(M1): Add the minimum supported Terraform version after the platform
  # toolchain standard is approved.

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # TODO(M1): Add the minimum supported AzureRM provider version after the
      # platform provider strategy is approved.
    }
  }
}
