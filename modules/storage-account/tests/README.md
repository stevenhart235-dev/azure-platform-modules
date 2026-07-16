# Tests

Native Terraform tests use the `.tftest.hcl` convention.

Current coverage:

- Valid input contract application.
- Output contract values.
- Tag pass-through behavior.
- Resource ID and primary Blob endpoint output derivation from the resource.
- Storage account name validation.
- Resource group name validation.
- Empty location validation.
- Account tier validation.
- Replication type validation.
- Tag key and value validation.

The current tests use Terraform native provider mocking. They are intended to
validate the module contract without requiring a real Azure subscription.

Mocked tests do not prove Azure deployment behavior. Real Azure deployment
validation must still run as part of release acceptance.
