# Storage Account Module

## Purpose

This module creates one Azure Storage Account using an explicit,
caller-supplied name, resource group name, location, and tag map.

It is a focused primitive module intended for future Azure Platform Framework
bootstrap state-storage deployment. It creates only the storage account.
Storage containers, private endpoints, private DNS, diagnostic settings, RBAC
assignments, management locks, and backend configuration are intentionally out
of scope.

## Resource Created

| Resource | Terraform label | Purpose |
| --- | --- | --- |
| `azurerm_storage_account` | `this` | Creates the Azure Storage Account. |

## Design Philosophy

The module deliberately avoids hidden naming and tagging behavior.

- The caller supplies the final storage account name.
- The caller supplies the resource group name.
- The caller supplies the Azure location.
- The caller supplies all tags.
- Tags are applied exactly as supplied.
- No provider or backend blocks exist in the child module.
- No tenant, subscription, region, environment, owner, or cost values are
  hard-coded in the module.

The naming standard currently recommends explicit caller-supplied names while
the enterprise naming convention is still being finalized. This module does not
generate names from local logic.

## Security Baseline

The module enforces the following storage account settings:

- HTTPS traffic only: `https_traffic_only_enabled = true`
- Minimum TLS version 1.2: `min_tls_version = "TLS1_2"`
- Public blob/container access disabled:
  `allow_nested_items_to_be_public = false`
- Shared access key authorization disabled:
  `shared_access_key_enabled = false`
- Infrastructure encryption enabled:
  `infrastructure_encryption_enabled = true`
- Storage firewall default action deny:
  `network_rules.default_action = "Deny"`
- Trusted Microsoft services network bypass:
  `network_rules.bypass = ["AzureServices"]`

These settings are not caller-configurable. This keeps the module aligned with
the platform remote-state security model, where normal access uses Microsoft
Entra ID and Azure RBAC rather than storage account keys or SAS tokens.

Operational consequence: when shared access key authorization is disabled,
consumers that manage data-plane child resources must use identity-based
authentication. For Terraform AzureRM resources that manage Storage containers,
blobs, or related data-plane items, root provider configuration may need the
provider's Azure AD storage authentication behavior enabled. Containers are
not created by this module.

## Bootstrap Public Network Exception

`public_network_access_enabled` is an explicit network lifecycle exception
exposed by this module.

The secure target state is `false`, and that is the default. A bootstrap lab may
temporarily set it to `true` so GitHub-hosted runners and authenticated
developer machines can reach the storage account before private networking,
private endpoints, and private-capable runners exist.

Enabling the public endpoint does not mean access is allowed from all networks.
The storage firewall still uses `default_action = "Deny"`. Callers must
explicitly provide one or more of the following when bootstrap access is
required:

- `network_ip_rules`: current public runner or developer egress IPv4 address
  or CIDR range.
- `network_subnet_ids`: approved subnet resource IDs.
- `network_bypass`: trusted Microsoft services bypass defaults to
  `AzureServices`; callers may explicitly select `Logging`, `Metrics`,
  `AzureServices`, or `None`.

These concepts are separate:

- Public endpoint enabled: the Azure public endpoint can be reached at the
  network boundary when `public_network_access_enabled = true`.
- Anonymous public blob access: disabled by
  `allow_nested_items_to_be_public = false`; this module does not allow public
  containers or blobs.
- Storage firewall default action: always `Deny`; explicit network rules or
  justified bypass values are required for access through the public endpoint.

Shared key authorization also remains disabled. Allowed network paths still
require identity-based authentication and Azure RBAC for normal workflows.

`AzureServices` is a limited trusted-services network exception. It does not
enable anonymous access, does not grant RBAC permissions, and does not allow
GitHub-hosted runners through the storage firewall. Bootstrap access from a
GitHub-hosted runner or developer machine still requires an explicit
`network_ip_rules` entry for the current public egress IP range, or an approved
subnet path. Deployments that require stricter isolation may set
`network_bypass = ["None"]`.

The expected future transition is to deploy private endpoint access through a
separate reusable capability, move runners and operators to private-capable
network paths, and then disable public network access again. At that point,
bootstrap IP allow rules should be removed from callers.

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

module "storage_account" {
  source = "../../"

  name                = "stplatformexample001"
  resource_group_name = "rg-example-platform-001"
  location            = "centralus"

  tags = {
    managed_by = "terraform"
    purpose    = "example"
  }
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

module "storage_account" {
  source = "../../"

  name                = "stsharedexample001"
  resource_group_name = "rg-example-shared-services-001"
  location            = "centralus"

  account_tier                   = "Standard"
  account_replication_type       = "ZRS"
  hierarchical_namespace_enabled = true
  public_network_access_enabled  = true

  # Documentation-only placeholder from TEST-NET-3.
  # Real bootstrap deployments must supply the current runner/developer
  # public egress IP range or an approved subnet ID.
  network_ip_rules = ["203.0.113.10"]

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

Root consumers own provider lock files. Example root lock files may be
generated during validation, but this module does not commit
`.terraform.lock.hcl` as part of the reusable child-module contract.

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `name` | `string` | yes | n/a | Final Azure storage account name supplied by the caller. |
| `resource_group_name` | `string` | yes | n/a | Name of the resource group where the storage account will be created. |
| `location` | `string` | yes | n/a | Azure location supplied by the caller from deployment configuration. |
| `tags` | `map(string)` | no | `{}` | Tags to apply exactly as supplied by the caller. |
| `account_tier` | `string` | no | `"Standard"` | Storage account tier. |
| `account_replication_type` | `string` | no | `"LRS"` | Storage account replication type. |
| `public_network_access_enabled` | `bool` | no | `false` | Whether public network access is enabled for the storage account. |
| `hierarchical_namespace_enabled` | `bool` | no | `false` | Whether hierarchical namespace is enabled for Azure Data Lake Storage Gen2 behavior. |
| `network_bypass` | `set(string)` | no | `["AzureServices"]` | Storage firewall bypass values for trusted Azure platform traffic. |
| `network_ip_rules` | `set(string)` | no | `[]` | Public IPv4 addresses or CIDR ranges allowed through the storage firewall. |
| `network_subnet_ids` | `set(string)` | no | `[]` | Virtual network subnet resource IDs allowed through the storage firewall. |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Storage account ID. |
| `name` | Storage account name. |
| `resource_group_name` | Storage account resource group name. |
| `location` | Storage account location. |
| `primary_blob_endpoint` | Primary Blob service endpoint for the storage account. |
| `tags` | Tags applied to the storage account. |

No access keys, connection strings, SAS tokens, or other credentials are
output.

## Validation Behavior

The module validates only caller-facing constraints that are useful and aligned
with Azure Storage Account behavior.

- `name` must be between 3 and 24 characters.
- `name` may contain only lowercase letters and numbers.
- `resource_group_name` must be between 1 and 90 characters.
- `location` must be a non-empty string.
- `account_tier` must be one of `Standard` or `Premium`.
- `account_replication_type` must be one of `LRS`, `GRS`, `RAGRS`, `ZRS`,
  `GZRS`, or `RAGZRS`.
- `network_bypass` values must be one or more of `Logging`, `Metrics`,
  `AzureServices`, or `None`.
- `network_bypass = ["None"]` must not be combined with other bypass values.
- Tag keys must be non-empty and no more than 512 characters.
- Tag values must be no more than 256 characters.

The module does not validate enterprise naming tokens, tag keys, tag casing, or
controlled tag values because those platform decisions are deferred to naming,
tagging, governance, and deployment configuration standards.

The module also does not expose `account_kind`, access tier, containers, blob
properties, private endpoints, RBAC, diagnostics, or locks. Those capabilities
require separate platform decisions or reusable modules.

## Tag Behavior

The storage account receives `var.tags` exactly as supplied by the caller.

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

## Provider Verification Notes

The module implementation was checked against the AzureRM `4.81.0` provider
schema and current official AzureRM `azurerm_storage_account` documentation.

Verified AzureRM arguments used by this module:

- `account_tier`
- `account_replication_type`
- `public_network_access_enabled`
- `is_hns_enabled`
- `https_traffic_only_enabled`
- `min_tls_version`
- `allow_nested_items_to_be_public`
- `shared_access_key_enabled`
- `infrastructure_encryption_enabled`
- `network_rules.default_action`
- `network_rules.bypass`
- `network_rules.ip_rules`
- `network_rules.virtual_network_subnet_ids`
- `tags`

## Testing Status

Native Terraform tests are defined under `tests/` using the `.tftest.hcl`
convention.

Current tests use Terraform native provider mocking to validate the module
contract without requiring a real Azure subscription.

Mocked contract tests validate Terraform configuration behavior such as:

- Input validation.
- Output wiring.
- Exact tag pass-through.
- Security baseline settings.
- Storage firewall default-deny behavior.
- Default trusted services bypass.
- Empty IP and subnet allow lists by default.
- Explicit network IP rule, subnet ID, and bypass pass-through.
- Public network access bootstrap exception wiring.
- Hierarchical namespace wiring.
- The `id` and `primary_blob_endpoint` outputs being derived from the managed
  resource.

Mocked tests do not prove Azure deployment behavior, Azure API behavior,
provider authentication, or real resource creation. Real Azure deployment
validation remains required before release acceptance.

## Limitations

- No storage containers are implemented.
- No private endpoints are implemented.
- No private DNS is implemented.
- No diagnostic settings are implemented.
- No RBAC assignments are implemented.
- No management locks are implemented.
- No backend configuration is implemented.
- No naming metadata or generated naming pattern is implemented.
- No module release tag has been created.
- Stable compatibility with Terraform `1.7.0` and AzureRM `4.0.0` must be
  validated in the minimum compatibility matrix before a stable release claims
  that compatibility.

Examples use placeholder values and must not be copied directly into production
deployment configuration.
