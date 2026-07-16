variable "name" {
  description = "Final Azure storage account name supplied by the caller. The name must be globally unique and use only lowercase letters and numbers."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24
    error_message = "The storage account name must be between 3 and 24 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.name))
    error_message = "The storage account name may contain only lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group where the storage account will be created."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.resource_group_name)) >= 1 && length(trimspace(var.resource_group_name)) <= 90
    error_message = "The resource group name must be between 1 and 90 characters."
  }
}

variable "location" {
  description = "Azure location supplied by the caller. This value must come from environment configuration in a deployment repository."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "The location must be a non-empty string."
  }
}

variable "tags" {
  description = "Tags to apply to the storage account exactly as supplied by the caller."
  type        = map(string)
  default     = {}
  nullable    = false

  validation {
    condition = alltrue([
      for key in keys(var.tags) :
      length(trimspace(key)) > 0 && length(key) <= 512
    ])
    error_message = "Tag keys must be non-empty and no more than 512 characters."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) :
      length(value) <= 256
    ])
    error_message = "Tag values must be no more than 256 characters."
  }
}

variable "account_tier" {
  description = "Storage account tier. AzureRM supports Standard and Premium."
  type        = string
  default     = "Standard"
  nullable    = false

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The account tier must be one of: Standard, Premium."
  }
}

variable "account_replication_type" {
  description = "Storage account replication type."
  type        = string
  default     = "LRS"
  nullable    = false

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "The account replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the storage account. Defaults to false; bootstrap labs may temporarily set true before private endpoint access exists."
  type        = bool
  default     = false
  nullable    = false
}

variable "hierarchical_namespace_enabled" {
  description = "Whether hierarchical namespace is enabled for Azure Data Lake Storage Gen2 behavior."
  type        = bool
  default     = false
  nullable    = false
}
