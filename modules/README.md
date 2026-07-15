# Modules

Reusable Terraform modules will live under this directory.

Expected future layout:

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

Do not add real environment root deployments, provider configuration, backend
configuration, state files, plan files, secrets, tenant IDs, subscription IDs,
regions, CIDRs, or real resource names here.

No Azure modules are implemented yet.
