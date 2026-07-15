provider "azurerm" {
  features {}
}

run "valid_resource_group_contract" {
  command = plan

  variables {
    name     = "rg-example-contract-001"
    location = "placeholder-region"
    tags = {
      managed_by = "terraform"
      purpose    = "contract-test"
    }
  }

  assert {
    condition     = azurerm_resource_group.this.name == "rg-example-contract-001"
    error_message = "Resource group name must match the caller-supplied name."
  }

  assert {
    condition     = azurerm_resource_group.this.location == "placeholder-region"
    error_message = "Resource group location must match the caller-supplied location."
  }

  assert {
    condition     = azurerm_resource_group.this.tags == var.tags
    error_message = "Resource group tags must be applied exactly as supplied by the caller."
  }
}

run "invalid_resource_group_name_too_long" {
  command = plan

  variables {
    name     = "rg-example-name-that-is-longer-than-the-azure-resource-group-limit-of-ninety-characters-001"
    location = "placeholder-region"
  }

  expect_failures = [
    var.name,
  ]
}

run "invalid_empty_tag_key" {
  command = plan

  variables {
    name     = "rg-example-invalid-tag-001"
    location = "placeholder-region"
    tags = {
      "" = "placeholder-value"
    }
  }

  expect_failures = [
    var.tags,
  ]
}
