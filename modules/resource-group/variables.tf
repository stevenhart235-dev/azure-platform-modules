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
  description = "Tags supplied by the caller. Modules must not invent environment-specific tag values."
  type        = map(string)
  default     = {}
  nullable    = false

  validation {
    condition = alltrue([
      for key, value in var.tags :
      length(trimspace(key)) > 0 && length(trimspace(value)) > 0
    ])
    error_message = "Tag keys and values must be non-empty strings."
  }
}
