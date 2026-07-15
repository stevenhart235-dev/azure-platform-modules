# Tests

Native Terraform tests use the `.tftest.hcl` convention.

Current coverage:

- Valid input contract planning.
- Output contract values.
- Tag pass-through behavior.
- Resource group name validation.
- Tag key validation.

The current tests use `command = plan`, so they are intended to validate the
module contract without deploying Azure resources.

Provider mocking may be considered after M1 selects the minimum supported
Terraform version. Until then, tests may still require normal AzureRM provider
initialization and authentication for planning.
