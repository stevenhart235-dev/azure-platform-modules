output "name" {
  description = "Final resource group name that will be used by the module."
  value       = var.name
}

output "location" {
  description = "Azure location that will be used by the module."
  value       = var.location
}

output "tags" {
  description = "Tags that will be applied by the module."
  value       = var.tags
}
