# Tests

Native Terraform tests use the `.tftest.hcl` convention.

Current coverage:

- Valid input contract planning.
- Output contract values.
- Tag pass-through behavior.
- Resource ID output derivation from the resource.
- Resource group name validation.
- Empty location validation.
- Tag key and value validation.

The current tests use Terraform native provider mocking with `command = plan`.
They are intended to validate the module contract without requiring a real
Azure subscription.

Mocked tests do not prove Azure deployment behavior. Real Azure deployment
validation must still run as part of release acceptance.
