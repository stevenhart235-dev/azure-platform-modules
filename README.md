# azure-platform-modules

Reusable Terraform modules for the Azure Platform Framework.

This repository contains environment-neutral Terraform child modules that can be
consumed by platform deployment repositories. Modules are product artifacts:
they expose stable inputs and outputs, are tested independently, and are
released through immutable semantic version tags.

## Repository Purpose

`azure-platform-modules` is responsible for:

- Reusable Terraform modules.
- Module examples.
- Module tests and test fixtures.
- Module documentation.
- Module release notes and semantic versioning.
- Azure Verified Module wrappers or compositions where approved.

Terraform is the authoritative Infrastructure as Code engine for this platform.
Terraform is the required engine for module validation, release acceptance, and
future module automation. OpenTofu compatibility is not currently a supported
contract.

## What Must Not Be Committed

Modules must not contain real or environment-specific values, including:

- Tenant IDs.
- Subscription IDs.
- Azure regions.
- CIDR ranges or enterprise IP allocations.
- Real resource names.
- Credentials, secrets, private keys, or tokens.
- Environment-specific configuration.
- Provider configuration.
- Backend configuration.
- Terraform state, state backups, or plan files.

Environment-specific configuration belongs in deployment repositories such as
`azure-platform-foundation` and `azure-platform-connectivity`, not in reusable
modules.

## Module Consumption

Deployment repositories must consume modules through immutable semantic version
tags. They must not depend on mutable branches such as `main` for production or
release-bound deployment code.

Semantic versioning expectations:

- `MAJOR` for breaking changes.
- `MINOR` for backward-compatible new functionality.
- `PATCH` for backward-compatible fixes or documentation corrections.

## Azure Verified Modules

Azure Verified Modules should be adopted directly, wrapped, or composed where
they satisfy platform requirements. Wrappers or compositions should exist only
when they enforce a meaningful platform contract such as naming, tagging,
diagnostics, private networking, identity, RBAC, policy, or other reusable
standards.

## Authoritative Standards

Architecture decisions and engineering standards live in the sibling
`azure-platform-architecture` repository. This repository references those
standards rather than copying or redefining them.

Relevant source documents:

- `../azure-platform-architecture/docs/adr/0001-iac-engine.md`
- `../azure-platform-architecture/docs/adr/0002-repository-separation.md`
- `../azure-platform-architecture/docs/standards/repository-standard.md`
- `../azure-platform-architecture/docs/standards/terraform-module-standard.md`

## Ownership

`CODEOWNERS` currently uses role-oriented placeholder teams. These placeholders
must be replaced when repository teams are configured in the source-control
platform.

Current placeholders:

- `@azure-platform/module-maintainers`
- `@azure-platform/security-reviewers`
- `@azure-platform/docs-maintainers`

## Future Directory Model

The expected module layout under `modules/` is:

```text
modules/
  <module-name>/
    main.tf
    variables.tf
    outputs.tf
    versions.tf
    locals.tf
    README.md
    examples/
      basic/
      complete/
    tests/
```

Optional Terraform files such as `data.tf`, `diagnostics.tf`,
`role_assignments.tf`, or `private_endpoints.tf` may be added when they improve
readability. Child modules must declare required providers and Terraform version
constraints, but must not configure providers or backends.

No Azure modules are implemented yet. This repository currently contains only
the foundation required before module development begins.
