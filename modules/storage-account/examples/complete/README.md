# Complete Example

This example demonstrates the optional deployment choices exposed by the
module: replication type, hierarchical namespace, and temporary public network
access for bootstrap-style scenarios.

The example includes a documentation-only TEST-NET-3 IP allow rule to show the
bootstrap pattern without using a real personal or enterprise IP address. A
real deployment must supply the current GitHub-hosted runner or developer
public egress IP range, or an approved subnet ID, before the storage firewall
will allow access.

The values are placeholders. Deployment repositories must provide real
environment values through reviewed configuration.

This example is a standalone root module with provider configuration so it can
be initialized and validated independently.

Backend blocks must never be added to examples.
