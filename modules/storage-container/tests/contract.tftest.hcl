mock_provider "azurerm" {
  mock_resource "azurerm_storage_container" {
    defaults = {
      id = "mock-storage-container-id"
    }
  }
}

run "default_private_storage_container_contract" {
  command = apply

  variables {
    name               = "tfstate"
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-platform-001/providers/Microsoft.Storage/storageAccounts/stplatformexample001"
  }

  assert {
    condition     = output.name == "tfstate"
    error_message = "The name output must match the caller-supplied storage container name."
  }

  assert {
    condition     = azurerm_storage_container.this.storage_account_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-platform-001/providers/Microsoft.Storage/storageAccounts/stplatformexample001"
    error_message = "The storage account ID must pass through to the storage container resource."
  }

  assert {
    condition     = azurerm_storage_container.this.container_access_type == "private"
    error_message = "The default container access type must be private."
  }

  assert {
    condition     = output.id == azurerm_storage_container.this.id
    error_message = "The id output must be derived from azurerm_storage_container.this.id."
  }

  assert {
    condition     = length(output.id) > 0
    error_message = "The id output must be non-empty after the mocked apply."
  }
}

run "explicit_storage_container_access_type_contract" {
  command = apply

  variables {
    name                  = "artifacts"
    storage_account_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-platform-001/providers/Microsoft.Storage/storageAccounts/stplatformexample001"
    container_access_type = "blob"
  }

  assert {
    condition     = azurerm_storage_container.this.container_access_type == "blob"
    error_message = "The explicit container access type must pass through to the storage container resource."
  }
}

run "invalid_empty_storage_container_name" {
  command = plan

  variables {
    name               = ""
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-platform-001/providers/Microsoft.Storage/storageAccounts/stplatformexample001"
  }

  expect_failures = [
    var.name,
  ]
}

run "invalid_empty_storage_account_id" {
  command = plan

  variables {
    name               = "tfstate"
    storage_account_id = ""
  }

  expect_failures = [
    var.storage_account_id,
  ]
}

run "invalid_container_access_type" {
  command = plan

  variables {
    name                  = "tfstate"
    storage_account_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-platform-001/providers/Microsoft.Storage/storageAccounts/stplatformexample001"
    container_access_type = "anonymous"
  }

  expect_failures = [
    var.container_access_type,
  ]
}
