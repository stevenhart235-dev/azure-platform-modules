# Security

## Reporting Security Issues

Do not create public issues for suspected vulnerabilities, exposed secrets, or
security-sensitive operational details.

Report security issues through the organization-approved private security
reporting process.

TODO: Replace this placeholder with the approved internal security reporting
channel when repository governance is configured.

## Prohibited Content

Do not commit:

- Secrets, credentials, passwords, private keys, certificates, or tokens.
- Terraform state or state backups.
- Terraform plan files.
- Real tenant IDs, subscription IDs, client IDs, or object IDs.
- Real Azure regions, CIDR ranges, resource names, or environment names.
- Local override files or developer-specific configuration.
- Provider caches, CLI configuration, or generated test artifacts.

## Security Review

Security review is required for changes that affect identity, RBAC, policy,
network exposure, secrets, encryption, logging, diagnostics, or compliance
posture.
