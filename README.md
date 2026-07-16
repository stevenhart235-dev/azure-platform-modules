# azure-platform-modules

Reusable Terraform child modules for the Azure Platform Framework.

This repository contains environment-neutral Terraform modules that can be
consumed by platform deployment repositories. Modules are product artifacts:
they expose stable inputs and outputs, include module-local examples and tests,
and are released through immutable semantic version tags when ready.

## Current Milestone

Current milestone: **M1 - Engineering Toolchain**.

The repository scaffold is in place, and the first reusable module has been
implemented. Work is still in progress for GitHub Actions, TFLint, Trivy, and
release automation. Do not treat this repository as fully production-ready
until the required validation and release gates are implemented and passing.

## Implemented Modules

| Module | Status | Notes |
| --- | --- | --- |
| `modules/resource-group` | Implemented, unreleased | Creates one Azure resource group with caller-supplied name, location, and tags. |

The Resource Group module has not yet been given a stable semantic version
release.

## Current Validation Status

Status snapshot as of 2026-07-16:

- Resource Group native Terraform tests pass: 6 passed, 0 failed.
- Basic and complete Resource Group examples validate and plan successfully.
- No Azure resources were applied.
- GitHub Actions implementation is not yet present.
- TFLint and Trivy configuration are still in progress.

This is a working status snapshot. Future pull requests must report the exact
commands run and their results. Never claim validation passed unless the command
actually ran.

## Supported Toolchain Baseline

Terraform is the authoritative Infrastructure as Code engine for this platform.
OpenTofu compatibility is not part of the supported contract.

Current accepted baseline:

- Approved Terraform execution version: `1.15.8`.
- Reusable module minimum Terraform version: `>= 1.7.0`.
- Reusable module AzureRM range: `>= 4.0.0, < 5.0.0`.
- AzureRM release-validation version: `4.80.0`.
- AzAPI is excluded until a real platform capability justifies it.

Reusable child modules declare compatibility constraints. Root deployments and
runnable root examples own provider configuration and dependency lock files.

## Repository Layout

```text
.
|-- docs/
|   `-- ai/
|       `-- assistant-guide.md
|-- examples/
|   `-- README.md
|-- modules/
|   |-- README.md
|   `-- resource-group/
|       |-- README.md
|       |-- main.tf
|       |-- variables.tf
|       |-- outputs.tf
|       |-- versions.tf
|       |-- examples/
|       |   |-- basic/
|       |   `-- complete/
|       `-- tests/
|-- scripts/
|   `-- README.md
|-- tests/
|   `-- README.md
|-- CHANGELOG.md
|-- CODEOWNERS
|-- CONTRIBUTING.md
|-- README.md
`-- SECURITY.md
```

## What Belongs Here

- Reusable Terraform child modules.
- Module-local tests.
- Module-local examples.
- Module documentation.
- Validation tooling.
- Release notes.
- Approved Azure Verified Module wrappers or compositions.

## What Must Not Be Committed

- Foundation or connectivity root deployments.
- Backend configuration in child modules.
- Provider configuration in child modules.
- Environment `tfvars` files.
- Terraform state, state backups, or plan files.
- Credentials, secrets, private keys, tokens, or pipeline secrets.
- Real tenant IDs or subscription IDs.
- Enterprise CIDRs or environment-specific values.
- Mutable production module references.

Runnable examples may configure providers because examples are root modules.
Examples must not configure backends or contain real environment values.

## Module Consumption

Deployment repositories must consume reusable modules through immutable module
references, such as semantic version tags or approved commit SHAs. Production
deployment code must not reference mutable branches such as `main`.

Independent module versioning is the expected direction for this repository.
The exact release tag naming convention must be documented before stable
module releases are created.

## Local Validation Commands

Run the relevant checks for the module or documentation being changed.

Resource Group module examples:

```powershell
terraform fmt -recursive modules/resource-group
Set-Location modules/resource-group
terraform test
```

Example validation:

```powershell
Set-Location examples/basic
terraform init
terraform validate
terraform plan

Set-Location ../complete
terraform init
terraform validate
terraform plan
```

Repository-wide future gates:

```powershell
terraform fmt -recursive .
terraform test
tflint --recursive
trivy config .
```

TFLint and Trivy configuration are still in progress. Do not report those gates
as passing until they are implemented and run.

## Authoritative Standards

Architecture decisions and engineering standards live in the sibling
`azure-platform-architecture` repository. This repository references those
standards rather than copying or redefining them.

Relevant source documents:

- `../azure-platform-architecture/docs/ai/assistant-guide.md`
- `../azure-platform-architecture/docs/adr/0001-iac-engine.md`
- `../azure-platform-architecture/docs/adr/0002-repository-separation.md`
- `../azure-platform-architecture/docs/adr/0003-terraform-toolchain-baseline.md`
- `../azure-platform-architecture/docs/standards/repository-standard.md`
- `../azure-platform-architecture/docs/standards/terraform-module-standard.md`
- `../azure-platform-architecture/docs/standards/naming-standard.md`
- `../azure-platform-architecture/docs/standards/tagging-standard.md`
- `../azure-platform-architecture/docs/standards/versioning-standard.md`
- `../azure-platform-architecture/docs/standards/engineering-validation-standard.md`

AI assistants and new contributors should also read
`docs/ai/assistant-guide.md` before making changes.

## Current Limitations

- No GitHub Actions workflows have been added.
- TFLint and Trivy are not yet implemented for this repository.
- The Resource Group module is implemented but unreleased.
- Stable release compatibility must still be validated against the approved
  matrix before a stable module release.
- No Azure resources should be applied from this repository as part of routine
  module development.
- CODEOWNERS uses placeholder role-oriented teams until source-control teams
  are configured.

## Contribution Workflow

All changes should be made through reviewed pull requests.

Before opening a pull request:

1. Read the relevant ADRs and standards in `azure-platform-architecture`.
2. Confirm the change belongs in `azure-platform-modules`.
3. Keep the pull request focused on one coherent change.
4. Do not add prohibited content.
5. Run applicable validation commands.
6. Document validation evidence, risk, rollback notes, and version impact.
7. Request review from the responsible CODEOWNERS.

Never commit or push generated Terraform state, plan files, credentials, local
override files, or environment-specific configuration.
