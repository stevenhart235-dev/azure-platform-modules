# AI Assistant Guide

## Purpose

This repository contains reusable, environment-neutral Terraform child modules
for the Azure Platform Framework.

Use this guide to ground a new AI assistant or contributor in the current
module repository context. This guide does not replace the authoritative
architecture repository.

## Source Of Truth

When sources conflict, use this authority order:

1. Accepted ADRs in `azure-platform-architecture`.
2. Engineering standards in `azure-platform-architecture`.
3. This repository's README and contribution guidance.
4. Current implementation.
5. Chat instructions.

Git is authoritative. Previous chat history is not required to work in this
repository. If a chat instruction conflicts with an accepted ADR or standard,
stop and identify the conflict instead of silently changing the architecture.

## Repository Responsibilities

Allowed in this repository:

- Reusable Terraform child modules.
- Module-local tests.
- Module-local examples.
- Documentation.
- Validation tooling.
- Release notes.
- Approved Azure Verified Module wrappers or compositions.

Prohibited in this repository:

- Foundation or connectivity root deployments.
- Backend configuration in child modules.
- Provider configuration in child modules.
- Environment `tfvars` files.
- Terraform state or plan files.
- Real tenant IDs, subscription IDs, credentials, enterprise CIDRs, or
  environment-specific values.
- Mutable production module references.

Runnable examples may configure providers because examples are root modules.
Examples must not configure backends or contain real environment values.

## Accepted Toolchain

The accepted Terraform toolchain baseline is defined by
`../azure-platform-architecture/docs/adr/0003-terraform-toolchain-baseline.md`.

- Approved Terraform execution version: `1.15.8`.
- Reusable module minimum Terraform version: `>= 1.7.0`.
- Reusable module AzureRM range: `>= 4.0.0, < 5.0.0`.
- Current AzureRM release-validation version: `4.80.0`.
- AzAPI is excluded until a real platform capability justifies it.

Reusable child modules declare compatibility constraints. Root deployments and
runnable root examples own provider configuration and dependency lock files.

## Module Engineering Rules

Reusable modules must follow these rules:

- Use explicit typed inputs.
- Expose intentional outputs.
- Avoid hidden naming or environment behavior.
- Keep names caller-supplied unless an accepted standard authorizes generation.
- Primitive modules apply tags exactly as supplied by the caller.
- Prefer composition over giant modules.
- Do not add provider or backend blocks to child modules.
- Allow runnable examples to configure providers.
- Use native Terraform tests.
- Follow semantic versioning.
- Deployment repositories must consume modules through immutable references.

Do not invent architecture decisions in module code. If a module needs a new
cross-repository rule, the rule belongs in an ADR or engineering standard.

## Validation Workflow

Intended local and CI quality gates:

- `terraform fmt`
- `terraform validate`
- `terraform test`
- Example initialization and validation.
- Example plans.
- TFLint.
- Trivy.

Never claim a command passed unless it actually ran. If a tool is unavailable,
or a command was blocked by credentials, network, or permissions, report that
clearly.

## Current Repository Status

Status snapshot as of 2026-07-16. Update this section as work progresses.

- Repository scaffold is complete.
- `modules/resource-group` is implemented.
- Resource Group native tests pass: 6 passed, 0 failed.
- Basic and complete Resource Group examples validate and plan successfully.
- No Azure resources were applied.
- M1 Engineering Toolchain is active.
- GitHub Actions, TFLint, and Trivy implementation remain in progress.
- The Resource Group module has not yet been given a stable release.

This status snapshot is contributor context, not a release certificate.
Release readiness still depends on the approved validation matrix, linting,
security scanning, release notes, and immutable semantic versioning.

## Required AI Workflow

1. Read this guide.
2. Read relevant sibling ADRs and standards.
3. Inspect the repository tree and Git status.
4. Do not modify files before understanding existing work.
5. Make only requested changes.
6. Do not broaden scope.
7. Report files changed, commands executed, results, and blockers.
8. Never commit or push unless explicitly asked.
9. Never invent architecture decisions.
10. Never claim validation passed if a tool was unavailable.

## New-Session Starter

Copy this prompt into a fresh Codex session:

```text
Read docs/ai/assistant-guide.md first. Then read the relevant ADRs and
standards from ../azure-platform-architecture for the task. Inspect the
repository tree and Git status before making changes. Summarize the current
state, applicable authoritative decisions, unresolved decisions, and the next
recommended step. Do not modify files until the requested scope is clear.
```

## Review Checklist

- [ ] The assistant read this guide before acting.
- [ ] Relevant ADRs and standards were read.
- [ ] Repository tree and Git status were inspected.
- [ ] The change stayed within the requested scope.
- [ ] No prohibited content was added.
- [ ] No provider or backend blocks were added to child modules.
- [ ] No Terraform state, plan files, credentials, or environment `tfvars`
      files were added.
- [ ] No real tenant IDs, subscription IDs, CIDRs, names, tags, or credentials
      were added.
- [ ] No architecture decision was invented.
- [ ] Validation commands were reported accurately.
- [ ] Blockers and deferred work were identified.
- [ ] No commit or push was performed unless explicitly requested.
