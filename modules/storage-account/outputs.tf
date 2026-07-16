output "id" {
  description = "Storage account ID."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "resource_group_name" {
  description = "Storage account resource group name."
  value       = azurerm_storage_account.this.resource_group_name
}

output "location" {
  description = "Storage account location."
  value       = azurerm_storage_account.this.location
}

output "primary_blob_endpoint" {
  description = "Primary Blob service endpoint for the storage account."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "tags" {
  description = "Tags applied to the storage account."
  value       = azurerm_storage_account.this.tags
}
