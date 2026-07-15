# Tests

Native Terraform tests using the `.tftest.hcl` convention will be added when
the Azure resource implementation begins and the M1 engineering toolchain
milestone defines the approved local and CI validation approach.

Expected future coverage:

- Required input validation.
- Resource group naming validation.
- Tag validation.
- Output contract stability.
- Example initialization and validation.

TODO(M1): Select the module test framework and validation command set.
TODO(M1): Decide whether provider mocking is available and appropriate after
the minimum supported Terraform version is selected.
TODO(M3): Add tests before implementing or releasing this module.
