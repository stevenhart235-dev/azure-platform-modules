variable "name" {
  description = "Final Azure Storage container name supplied by the caller."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 63
    error_message = "The storage container name must be between 3 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$", var.name))
    error_message = "The storage container name may contain only lowercase letters, numbers, and hyphens, and must start and end with a lowercase letter or number."
  }

  validation {
    condition     = !can(regex("--", var.name))
    error_message = "The storage container name must not contain consecutive hyphens."
  }
}

variable "storage_account_id" {
  description = "Resource ID of the existing Azure Storage Account that will contain this container."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.storage_account_id)) > 0
    error_message = "The storage account ID must be a non-empty string."
  }
}

variable "container_access_type" {
  description = "Storage container access type. Defaults to private to avoid anonymous access."
  type        = string
  default     = "private"
  nullable    = false

  validation {
    condition     = contains(["private", "blob", "container"], var.container_access_type)
    error_message = "The container access type must be one of: private, blob, container."
  }
}
