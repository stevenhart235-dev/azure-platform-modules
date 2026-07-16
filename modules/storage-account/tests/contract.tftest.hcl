mock_provider "azurerm" {
  mock_resource "azurerm_storage_account" {
    defaults = {
      id                    = "mock-storage-account-id"
      primary_blob_endpoint = "https://stexamplecontract001.blob.core.windows.net/"
    }
  }
}

run "valid_storage_account_contract" {
  command = apply

  variables {
    name                = "stexamplecontract001"
    resource_group_name = "rg-example-contract-001"
    location            = "placeholder-region"
    tags = {
      managed_by = "terraform"
      purpose    = "contract-test"
    }
  }

  assert {
    condition     = output.name == "stexamplecontract001"
    error_message = "The name output must match the caller-supplied storage account name."
  }

  assert {
    condition     = output.resource_group_name == "rg-example-contract-001"
    error_message = "The resource_group_name output must match the caller-supplied resource group name."
  }

  assert {
    condition     = output.location == "placeholder-region"
    error_message = "The location output must match the caller-supplied location."
  }

  assert {
    condition = output.tags == tomap({
      managed_by = "terraform"
      purpose    = "contract-test"
    })
    error_message = "The tags output must preserve the exact caller-supplied tag map."
  }

  assert {
    condition     = output.id == azurerm_storage_account.this.id
    error_message = "The id output must be derived from azurerm_storage_account.this.id."
  }

  assert {
    condition     = output.primary_blob_endpoint == azurerm_storage_account.this.primary_blob_endpoint
    error_message = "The primary_blob_endpoint output must be derived from azurerm_storage_account.this.primary_blob_endpoint."
  }

  assert {
    condition     = length(output.id) > 0
    error_message = "The id output must be non-empty after the mocked apply."
  }

  assert {
    condition     = azurerm_storage_account.this.network_rules[0].default_action == "Deny"
    error_message = "The storage firewall default action must be Deny."
  }

  assert {
    condition     = length(azurerm_storage_account.this.network_rules[0].bypass) == 0
    error_message = "The default network bypass allow list must be empty."
  }

  assert {
    condition     = length(azurerm_storage_account.this.network_rules[0].ip_rules) == 0
    error_message = "The default network IP allow list must be empty."
  }

  assert {
    condition     = length(azurerm_storage_account.this.network_rules[0].virtual_network_subnet_ids) == 0
    error_message = "The default network subnet allow list must be empty."
  }
}

run "complete_storage_account_contract" {
  command = apply

  variables {
    name                           = "stexamplecomplete001"
    resource_group_name            = "rg-example-complete-001"
    location                       = "placeholder-region"
    account_tier                   = "Standard"
    account_replication_type       = "ZRS"
    hierarchical_namespace_enabled = true
    public_network_access_enabled  = true
    network_bypass                 = ["Logging", "Metrics"]
    network_ip_rules               = ["203.0.113.10"]
    network_subnet_ids             = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-network-001/providers/Microsoft.Network/virtualNetworks/vnet-example-001/subnets/snet-example-001"]
  }

  assert {
    condition     = azurerm_storage_account.this.account_tier == "Standard"
    error_message = "The account tier must be passed through to the storage account resource."
  }

  assert {
    condition     = azurerm_storage_account.this.account_replication_type == "ZRS"
    error_message = "The replication type must be passed through to the storage account resource."
  }

  assert {
    condition     = azurerm_storage_account.this.is_hns_enabled == true
    error_message = "The hierarchical namespace setting must be passed through to is_hns_enabled."
  }

  assert {
    condition     = azurerm_storage_account.this.public_network_access_enabled == true
    error_message = "The public network access bootstrap exception must be caller controlled."
  }

  assert {
    condition     = azurerm_storage_account.this.https_traffic_only_enabled == true
    error_message = "HTTPS-only traffic must be enforced."
  }

  assert {
    condition     = azurerm_storage_account.this.min_tls_version == "TLS1_2"
    error_message = "Minimum TLS version must be enforced as TLS1_2."
  }

  assert {
    condition     = azurerm_storage_account.this.allow_nested_items_to_be_public == false
    error_message = "Public nested item access must be disabled."
  }

  assert {
    condition     = azurerm_storage_account.this.shared_access_key_enabled == false
    error_message = "Shared access key authorization must be disabled."
  }

  assert {
    condition     = azurerm_storage_account.this.infrastructure_encryption_enabled == true
    error_message = "Infrastructure encryption must be enabled."
  }

  assert {
    condition     = azurerm_storage_account.this.network_rules[0].default_action == "Deny"
    error_message = "Enabling public network access must not change the storage firewall default action to Allow."
  }

  assert {
    condition     = toset(azurerm_storage_account.this.network_rules[0].bypass) == toset(["Logging", "Metrics"])
    error_message = "Network bypass values must pass through to the storage account firewall."
  }

  assert {
    condition     = toset(azurerm_storage_account.this.network_rules[0].ip_rules) == toset(["203.0.113.10"])
    error_message = "Network IP rules must pass through to the storage account firewall."
  }

  assert {
    condition     = toset(azurerm_storage_account.this.network_rules[0].virtual_network_subnet_ids) == toset(["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-network-001/providers/Microsoft.Network/virtualNetworks/vnet-example-001/subnets/snet-example-001"])
    error_message = "Network subnet IDs must pass through to the storage account firewall."
  }
}

run "invalid_storage_account_name_too_short" {
  command = plan

  variables {
    name                = "st"
    resource_group_name = "rg-example-invalid-name-001"
    location            = "placeholder-region"
  }

  expect_failures = [
    var.name,
  ]
}

run "invalid_storage_account_name_uppercase" {
  command = plan

  variables {
    name                = "stExampleInvalid001"
    resource_group_name = "rg-example-invalid-name-001"
    location            = "placeholder-region"
  }

  expect_failures = [
    var.name,
  ]
}

run "invalid_resource_group_name_empty" {
  command = plan

  variables {
    name                = "stexampleinvalid001"
    resource_group_name = ""
    location            = "placeholder-region"
  }

  expect_failures = [
    var.resource_group_name,
  ]
}

run "invalid_empty_location" {
  command = plan

  variables {
    name                = "stexampleinvalid002"
    resource_group_name = "rg-example-empty-location-001"
    location            = ""
  }

  expect_failures = [
    var.location,
  ]
}

run "invalid_account_tier" {
  command = plan

  variables {
    name                = "stexampleinvalid003"
    resource_group_name = "rg-example-invalid-tier-001"
    location            = "placeholder-region"
    account_tier        = "Basic"
  }

  expect_failures = [
    var.account_tier,
  ]
}

run "invalid_account_replication_type" {
  command = plan

  variables {
    name                     = "stexampleinvalid004"
    resource_group_name      = "rg-example-invalid-replication-001"
    location                 = "placeholder-region"
    account_replication_type = "RAGRS2"
  }

  expect_failures = [
    var.account_replication_type,
  ]
}

run "invalid_network_bypass_value" {
  command = plan

  variables {
    name                = "stexampleinvalid008"
    resource_group_name = "rg-example-invalid-bypass-001"
    location            = "placeholder-region"
    network_bypass      = ["Storage"]
  }

  expect_failures = [
    var.network_bypass,
  ]
}

run "invalid_network_bypass_none_combination" {
  command = plan

  variables {
    name                = "stexampleinvalid009"
    resource_group_name = "rg-example-invalid-bypass-002"
    location            = "placeholder-region"
    network_bypass      = ["None", "Logging"]
  }

  expect_failures = [
    var.network_bypass,
  ]
}

run "invalid_empty_tag_key" {
  command = plan

  variables {
    name                = "stexampleinvalid005"
    resource_group_name = "rg-example-invalid-tag-001"
    location            = "placeholder-region"
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
    name                = "stexampleinvalid006"
    resource_group_name = "rg-example-tag-key-length-001"
    location            = "placeholder-region"
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
    name                = "stexampleinvalid007"
    resource_group_name = "rg-example-tag-value-length-001"
    location            = "placeholder-region"
    tags = {
      placeholder_key = join("", [for index in range(257) : "v"])
    }
  }

  expect_failures = [
    var.tags,
  ]
}
