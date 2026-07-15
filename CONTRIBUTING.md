# Contributing

Thank you for contributing to `azure-platform-modules`.

This repository contains reusable, environment-neutral Terraform modules only.
Changes must follow the authoritative standards in
`../azure-platform-architecture`.

## Contribution Expectations

- Use pull requests for all changes.
- Keep feature branches short-lived.
- Keep each pull request focused on one coherent change.
- Link the related issue, ADR, roadmap item, or work item where applicable.
- Do not commit secrets, credentials, Terraform state, plan files, local
  overrides, provider caches, or environment-specific configuration.
- Use placeholder values in documentation, examples, and tests.
- Do not add provider configuration or backend configuration to reusable child
  modules.
- Do not add CI/CD workflows until the repository automation design is approved.

## Module Change Expectations

Future modules must:

- Have a focused platform purpose.
- Expose typed, documented, validated inputs.
- Expose intentional documented outputs.
- Avoid tenant-specific, subscription-specific, region-specific,
  address-specific, workload-specific, or secret values.
- Support consumption from deployment repositories without modifying module
  source.
- Follow semantic versioning.
- Use Terraform as the authoritative engine.
- Adopt or compose Azure Verified Modules where appropriate.

## Validation

For this foundation scaffold, review is documentation-only.

For future module changes, pull requests are expected to include validation
evidence appropriate to the change, such as:

- `terraform fmt`
- `terraform validate`
- TFLint
- Security scanning
- Module tests
- Example validation
- Documentation checks

The exact automation implementation is intentionally deferred.

## Reviews

Pull requests must be approved by the responsible role-based owners. Security
review is required for changes that affect identity, RBAC, policy, network
exposure, secrets, encryption, logging, or compliance posture.
