mock_provider "azurerm" {
  mock_resource "azurerm_resource_group" {
    defaults = {
      id = "mock-resource-group-id"
    }
  }
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
    condition     = output.name == "rg-example-contract-001"
    error_message = "The name output must match the caller-supplied resource group name."
  }

  assert {
    condition     = output.location == "placeholder-region"
    error_message = "The location output must match the caller-supplied location."
  }

  assert {
    condition = output.tags == {
      managed_by = "terraform"
      purpose    = "contract-test"
    }
    error_message = "The tags output must preserve the exact caller-supplied tag map."
  }

  assert {
    condition     = output.id == azurerm_resource_group.this.id
    error_message = "The id output must be derived from azurerm_resource_group.this.id."
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

run "invalid_empty_location" {
  command = plan

  variables {
    name     = "rg-example-empty-location-001"
    location = ""
  }

  expect_failures = [
    var.location,
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

run "invalid_tag_key_too_long" {
  command = plan

  variables {
    name     = "rg-example-tag-key-length-001"
    location = "placeholder-region"
    tags = {
      (join("", [for index in range(513) : "k"])) = "placeholder-value"
    }
  }

  expect_failures = [
    var.tags,
  ]
}

run "invalid_tag_value_too_long" {
  command = plan

  variables {
    name     = "rg-example-tag-value-length-001"
    location = "placeholder-region"
    tags = {
      placeholder_key = join("", [for index in range(257) : "v"])
    }
  }

  expect_failures = [
    var.tags,
  ]
}
