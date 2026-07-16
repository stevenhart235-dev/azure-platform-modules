# Storage Container Module

## Purpose

This module creates one Azure Storage container using an explicit,
caller-supplied name, storage account ID, and access type.

It is a focused primitive module intended for reusable Azure Platform
Framework storage composition. It creates only the storage container. Storage
Accounts, RBAC assignments, Private Endpoints, private DNS, diagnostic
settings, management locks, blobs, and backend configuration are intentionally
out of scope.

## Resource Created

| Resource | Terraform label | Purpose |
| --- | --- | --- |
| `azurerm_storage_container` | `this` | Creates the Azure Storage container. |

## Design Philosophy

The module deliberately avoids hidden naming and dependency behavior.

- The caller supplies the final storage container name.
- The caller supplies the existing storage account ID.
- The caller explicitly opts in to non-private access when required.
- No provider or backend blocks exist in the child module.
- No tenant, subscription, region, environment, owner, or cost values are
  hard-coded in the module.

Storage Accounts are separate modules. This module consumes an existing
storage account ID and does not create or configure the account.

## Security Defaults

The default `container_access_type` is `private`.

This avoids exposing anonymous access through module defaults. Azure Storage
containers can allow anonymous read access when configured as `blob` or
`container`, but anonymous access is a workload and governance decision that
must be explicit. Keeping the default private aligns the module with
least-privilege behavior and prevents accidental public data exposure.

This module does not output credentials, SAS tokens, connection strings, or
storage account keys.

## Basic Usage

```hcl
terraform {
  required_version = "= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.80"
    }
  }
}

provider "azurerm" {
  features {}
}

module "storage_container" {
  source = "../../"

  name               = "tfstate"
  storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-platform-001/providers/Microsoft.Storage/storageAccounts/stplatformexample001"
}
```

## Complete Usage

```hcl
terraform {
  required_version = "= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.80"
    }
  }
}

provider "azurerm" {
  features {}
}

module "storage_container" {
  source = "../../"

  name                  = "tfstate"
  storage_account_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-platform-001/providers/Microsoft.Storage/storageAccounts/stplatformexample001"
  container_access_type = "private"
}
```

See:

- `examples/basic`
- `examples/complete`

The example directories are standalone root modules with provider
configuration. They intentionally do not include backend blocks.

Root consumers own provider lock files. Example root lock files may be
generated during validation, but this module does not commit
`.terraform.lock.hcl` as part of the reusable child-module contract.

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `name` | `string` | yes | n/a | Final Azure Storage container name supplied by the caller. |
| `storage_account_id` | `string` | yes | n/a | Resource ID of the existing Azure Storage Account that will contain this container. |
| `container_access_type` | `string` | no | `"private"` | Storage container access type. |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Storage container ID. |
| `name` | Storage container name. |

No credentials, SAS tokens, connection strings, storage account keys, or other
secrets are output.

## Validation Behavior

The module validates only caller-facing constraints that are useful and aligned
with Azure Storage container behavior.

- `name` must be between 3 and 63 characters.
- `name` may contain only lowercase letters, numbers, and hyphens.
- `name` must start and end with a lowercase letter or number.
- `name` must not contain consecutive hyphens.
- `storage_account_id` must be a non-empty string.
- `container_access_type` must be one of `private`, `blob`, or `container`.

The module does not validate enterprise naming tokens, naming prefixes, storage
account existence, RBAC, anonymous access governance policy, or whether the
target storage account allows anonymous access. Those checks belong in
deployment configuration, Azure Policy, or release validation.

## Version Compatibility Status

Terraform is the authoritative engine for this platform.

This child module declares:

- Minimum supported Terraform version: `>= 1.7.0`
- Supported AzureRM major version: `>= 4.0.0, < 5.0.0`

The approved release-validation toolchain is:

- Terraform CLI: `1.15.8`
- AzureRM provider: `4.81.0`

Runnable examples use root constraints that match the approved release
validation baseline:

- Terraform: `= 1.15.8`
- AzureRM: `~> 4.80`

Root deployments and runnable root examples own provider lock files. Reusable
child modules must not rely on module-level lock files to define the consumer
dependency contract.

## Testing Status

Native Terraform tests are defined under `tests/` using the `.tftest.hcl`
convention.

Current tests use Terraform native provider mocking to validate the module
contract without requiring a real Azure subscription.

Mocked contract tests validate Terraform configuration behavior such as:

- Input validation.
- Output wiring.
- Name pass-through.
- Storage account ID pass-through.
- Default private access.
- Explicit access type pass-through.
- The `id` output being derived from the managed resource.

Mocked tests do not prove Azure deployment behavior, Azure API behavior,
provider authentication, or real resource creation. Real Azure deployment
validation remains required before release acceptance.

## Limitations

- No Storage Accounts are implemented.
- No RBAC assignments are implemented.
- No Private Endpoints are implemented.
- No private DNS is implemented.
- No diagnostic settings are implemented.
- No management locks are implemented.
- No blobs are implemented.
- No backend configuration is implemented.
- No naming metadata or generated naming pattern is implemented.
- No module release tag has been created.
- Stable compatibility with Terraform `1.7.0` and AzureRM `4.0.0` must be
  validated in the minimum compatibility matrix before a stable release claims
  that compatibility.

Examples use placeholder values and must not be copied directly into production
deployment configuration.

## Non-goals

This module intentionally does not:

- Create or configure Storage Accounts.
- Configure RBAC.
- Configure Private Endpoints.
- Configure diagnostics.
- Configure anonymous access policy on the parent storage account.
- Generate names.
- Manage Terraform backend state.
- Output credentials, SAS tokens, connection strings, or storage keys.
