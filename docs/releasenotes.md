# Release Notes

The Release Notes summarize and describe changes released in Cloudbreak.

## Fixes

This release includes the following fixes and improvements:

| Feature | Description |
|----|----|
| Ability to create cluster without public IP | We are supporting to create cluster on Aws without public IPs. (Deploying cluster into a private Subnet) |
| UI pageload fix | Sometimes the UI load was hanging. |
| Ability to use Cloudbreak with instance profile | THis optional is available if you want to run CB on a separate management host and it can only assume an IAM role, due to security reasons Aws keys will be rotated periodically but can be fetched or renewed from instance metadata. |
| Lazy format fix on Azure | Azure format was extremely slow when more than 16 disks are attached. |

## Technical Preview

This release includes the following Technical Preview features and improvements:

| Feature | Description |
|----|----|
| Mesos | **Technical Preview** Support for Mesos cloud provider. |
| Kerberos | **Technical Preview** Support for enabling Kerberos on the HDP clusters deployed by Cloudbreak. See [Kerberos](kerberos.md) for more information. |
| SSSD | **Technical Preview** Support for configuring System Security Services Daemon (SSSD) to help with cluster user management. See [SSSD](sssd.md) for more information. |
| Platforms | **Technical Preview** Support for defining Platforms to relate different configurations together. See [Platforms](topologies.md) for more information. |
