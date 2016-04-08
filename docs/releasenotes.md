# Release Notes

The Release Notes summarize and describe changes released in Cloudbreak.

## Fixes

This release includes the following fixes and improvements:

| Feature | Description |
|----|----|
| Cloudbreak Cluster installation | [Fixed hanging cluster installation](https://github.com/sequenceiq/cloudbreak/issues/1461). |
| Azure Persistent Storage name fix | Storage name generation was buggy after some API change. |
| GCP attached disk type was buggy | Attached disk was buggy after some API change. |

## Technical Preview

This release includes the following Technical Preview features and improvements:

| Feature | Description |
|----|----|
| Mesos | **Technical Preview** Support for Mesos cloud provider. |
| Kerberos | **Technical Preview** Support for enabling Kerberos on the HDP clusters deployed by Cloudbreak. See [Kerberos](kerberos.md) for more information. |
| SSSD | **Technical Preview** Support for configuring System Security Services Daemon (SSSD) to help with cluster user management. See [SSSD](sssd.md) for more information. |
| Platforms | **Technical Preview** Support for defining Platforms to relate different configurations together. See [Platforms](topologies.md) for more information. |


## Behavioral Changes

This release introduces the following changes in behavior as compared to previous Cloudbreak versions:

| Title | Description |
|----|----|
| Cloudbreak Web UI | Network creation form changes (easier creation of existing network). |


