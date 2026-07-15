# Resource Group Module

## Purpose

This module defines the interface for a reusable Azure resource group module.
It is the reference implementation pattern for future modules in this
repository.

The module is intentionally scaffold-only at this milestone. It does not create
an Azure resource group yet.

## Design Philosophy

This module follows the platform standards by keeping caller decisions explicit,
typed, validated, documented, and environment-neutral.

Design choices:

- Callers supply the final resource group name.
- Callers supply the Azure location.
- Callers supply environment-specific tags.
- Defaults are used only where they are broadly safe.
- Outputs expose stable composition contracts.
- Provider and backend configuration remain the responsibility of root
  deployments.

The naming standard currently recommends explicit caller-supplied names while
the enterprise naming convention is still being finalized. This module therefore
does not generate names from hidden local logic.

## Current Implementation Status

This scaffold defines the module contract only.

Not implemented yet:

- `azurerm_resource_group`
- Final Terraform and AzureRM provider version constraints
- Provider configuration in runnable examples
- Resource locks
- Role assignments
- Policy assignments
- Module tests

## Example Usage

Basic usage:

```hcl
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

Complete usage:

```hcl
module "resource_group" {
  source = "../../"

  name     = "rg-example-shared-services-001"
  location = "placeholder-region"

  tags = {
    managed_by          = "terraform"
    environment         = "placeholder-environment"
    workload            = "placeholder-workload"
    data_classification = "placeholder-classification"
  }
}
```

See:

- `examples/basic`
- `examples/complete`

The example directories are standalone root modules. Provider configuration may
be added to those examples when the Azure resource implementation begins so
they can be initialized and validated independently. Backend blocks must never
be added to module examples.

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `name` | `string` | yes | n/a | Final Azure resource group name supplied by the caller. |
| `location` | `string` | yes | n/a | Azure location supplied by the caller. |
| `tags` | `map(string)` | no | `{}` | Tags supplied by the caller. |

## Outputs

| Name | Description |
| --- | --- |
| `name` | Final resource group name that will be used by the module. |
| `location` | Azure location that will be used by the module. |
| `tags` | Tags that will be applied by the module. |

## Validation

The scaffold validates:

- Resource group name length.
- Resource group name characters.
- Resource group names do not end with a period.
- Location is provided as a non-empty caller decision.
- Tag keys and values are non-empty.

## Compatibility

Terraform is the authoritative engine for this platform.

The exact supported Terraform and AzureRM provider version constraints are
deferred until the M1 engineering toolchain milestone selects approved
versions.

## TODOs Before Implementation

- TODO(M1): Establish the minimum supported Terraform version.
- TODO(M1): Establish the minimum supported AzureRM provider version.
- TODO(M1): Add validation and test commands once the local and CI toolchain is
  approved.
- TODO(M3): Implement `azurerm_resource_group` after this interface is reviewed
  and accepted.
- TODO(M3): Add provider configuration to runnable examples when Azure resource
  implementation begins. Do not add backend blocks.
- TODO(M3): Decide whether resource locks belong in this module or a separate
  composition module.
- TODO(M3): Decide whether resource-group-level RBAC belongs in this module or
  a separate role assignment module.
- TODO(Naming): Revisit whether this module should accept structured naming
  metadata after the enterprise naming convention is finalized.

## Limitations

This module is not deployable as an Azure resource yet. It is a contract and
documentation scaffold only.

Examples use placeholder values and must not be copied directly into production
deployment configuration.
