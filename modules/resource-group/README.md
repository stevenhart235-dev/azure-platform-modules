# Resource Group Module

## Purpose

This module creates one Azure resource group using an explicit,
caller-supplied name, location, and tag map.

It is the first reference implementation for reusable modules in this
repository. Future modules should follow the same pattern: focused scope,
typed inputs, useful validation, explicit outputs, environment-neutral behavior,
and no child-module provider or backend configuration.

## Resource Created

| Resource | Terraform label | Purpose |
| --- | --- | --- |
| `azurerm_resource_group` | `this` | Creates the Azure resource group. |

## Design Philosophy

The module deliberately avoids hidden naming and tagging behavior.

- The caller supplies the final resource group name.
- The caller supplies the Azure location.
- The caller supplies all tags.
- Tags are applied exactly as supplied.
- No provider or backend blocks exist in the child module.
- No tenant, subscription, region, environment, owner, or cost values are
  hard-coded in the module.

The naming standard currently recommends explicit caller-supplied names while
the enterprise naming convention is still being finalized. This module does not
generate names from local logic.

## Basic Usage

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../"

  name     = "rg-example-platform-001"
  location = "placeholder-region"

  tags = {
    managed_by = "terraform"
    purpose    = "example"
  }
}
```

## Complete Usage

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../"

  name     = "rg-example-shared-services-001"
  location = "placeholder-region"

  tags = {
    business_unit       = "placeholder-business-unit"
    cost_center         = "placeholder-cost-center"
    criticality         = "placeholder-criticality"
    data_classification = "placeholder-data-classification"
    environment         = "placeholder-environment"
    lifecycle           = "placeholder-lifecycle"
    managed_by          = "terraform"
    owner               = "placeholder-owner-group"
    support_contact     = "placeholder-support-group"
    workload            = "placeholder-workload"
  }
}
```

See:

- `examples/basic`
- `examples/complete`

The example directories are standalone root modules with provider
configuration. They intentionally do not include backend blocks.

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `name` | `string` | yes | n/a | Final Azure resource group name supplied by the caller. |
| `location` | `string` | yes | n/a | Azure location supplied by the caller from deployment configuration. |
| `tags` | `map(string)` | no | `{}` | Tags to apply exactly as supplied by the caller. |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Resource group ID. |
| `name` | Resource group name. |
| `location` | Resource group location. |
| `tags` | Tags applied to the resource group. |

## Validation Behavior

The module validates only caller-facing constraints that are useful and aligned
with Azure resource group behavior.

- `name` must be between 1 and 90 characters.
- `name` may contain letters, numbers, underscores, periods, parentheses, and
  hyphens.
- `name` must not end with a period.
- `location` must be a non-empty string.
- Tag keys must be non-empty and no more than 512 characters.
- Tag values must be no more than 256 characters.

The module does not validate enterprise naming tokens, tag keys, tag casing, or
controlled tag values because those platform decisions are deferred to naming,
tagging, governance, and deployment configuration standards.

## Tag Behavior

The resource group receives `var.tags` exactly as supplied by the caller.

This module does not:

- Add tags.
- Merge tags.
- Overwrite caller-supplied tags.
- Invent enterprise tag values.
- Supply environment-specific tag defaults.

Root deployments and high-level composition modules are responsible for
computing effective enterprise tags before calling this primitive module.

## Version Compatibility Status

Terraform is the authoritative engine for this platform.

`versions.tf` declares the AzureRM provider source but does not set Terraform
or AzureRM version constraints yet. The approved minimum supported Terraform
version and AzureRM provider version are deferred to the M1 engineering
toolchain and provider strategy decisions.

This module should not be released as production-ready until those constraints
are approved and added.

## Testing Status

Native Terraform tests are defined under `tests/` using the `.tftest.hcl`
convention.

Current tests use `command = plan` to validate the module contract without
deploying Azure resources where practical. Until M1 selects the minimum
supported Terraform version and provider mocking approach, tests may still
require normal AzureRM provider initialization and authentication.

## Limitations

- No resource locks are implemented.
- No RBAC assignments are implemented.
- No policy assignments are implemented.
- No naming metadata or generated naming pattern is implemented.
- No module release tag has been created.
- Version constraints are deferred until M1.

Examples use placeholder values and must not be copied directly into production
deployment configuration.
