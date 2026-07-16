resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  https_traffic_only_enabled        = true
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false
  shared_access_key_enabled         = false
  infrastructure_encryption_enabled = true

  public_network_access_enabled = var.public_network_access_enabled
  is_hns_enabled                = var.hierarchical_namespace_enabled

  network_rules {
    default_action             = "Deny"
    bypass                     = var.network_bypass
    ip_rules                   = var.network_ip_rules
    virtual_network_subnet_ids = var.network_subnet_ids
  }

  tags = var.tags
}
