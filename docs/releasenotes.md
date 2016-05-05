# Release Notes

The Release Notes summarize and describe changes released in Cloudbreak.

## Fixes

This release includes the following fixes and improvements:

| Feature | Description |
|----|----|
| Ability to create clusters without public IP | In case a cluster is deployd in a private subnet then instances will not have public IP addresses. |
| UI pageload fix | Sometimes the UI load was hanging. |
| Ability to use Cloudbreak with IAM instance profiles | In case you already have instance profiles roles configured (and they can assume roles) you can pass it to Cloudbreak. |
| Lazy format fix on Azure | Azure format was extremely slow when more than 16 disks are attached. |

## Technical Preview

This release includes the following Technical Preview features and improvements:

| Feature | Description |
|----|----|
| Mesos | **Technical Preview** Support for Mesos cloud provider. |
| Kerberos | **Technical Preview** Support for enabling Kerberos on the HDP clusters deployed by Cloudbreak. See [Kerberos](kerberos.md) for more information. |
| SSSD | **Technical Preview** Support for configuring System Security Services Daemon (SSSD) to help with cluster user management. See [SSSD](sssd.md) for more information. |
| Platforms | **Technical Preview** Support for defining Platforms to relate different configurations together. See [Platforms](topologies.md) for more information. |
