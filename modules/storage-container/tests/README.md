# Tests

Native Terraform tests use the `.tftest.hcl` convention.

Current coverage:

- Valid default input contract application.
- Name pass-through behavior.
- Storage account ID pass-through behavior.
- Default private container access type.
- Explicit container access type pass-through.
- Resource ID output derivation from the resource.
- Empty name validation.
- Empty storage account ID validation.
- Container access type validation.

The current tests use Terraform native provider mocking. They are intended to
validate the module contract without requiring a real Azure subscription.

Mocked tests do not prove Azure deployment behavior. Real Azure deployment
validation must still run as part of release acceptance.
