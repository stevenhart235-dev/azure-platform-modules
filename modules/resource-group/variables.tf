variable "name" {
  description = "Final Azure resource group name supplied by the caller."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.name)) >= 1 && length(trimspace(var.name)) <= 90
    error_message = "The resource group name must be between 1 and 90 characters."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9_.()\\-]+$", var.name))
    error_message = "The resource group name may contain only letters, numbers, underscores, periods, parentheses, and hyphens."
  }

  validation {
    condition     = !endswith(var.name, ".")
    error_message = "The resource group name must not end with a period."
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
  description = "Tags to apply to the resource group exactly as supplied by the caller."
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
