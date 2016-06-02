# Release Notes

The Release Notes document describes new features and fixes incorporated in this version of Cloudbreak.

## Fixes

This release includes the following fixes and improvements:

| Feature | Description |
|----|----|
| Creating a cluster without public IP | We now support creating clusters on AWS without public IPs (Deploying a cluster into a private subnet). |
| UI pageload | We fixed the issue with the hanging UI load. |
| Using Cloudbreak with instance profile | This option is now available if you want to run Cloudbreak on a separate management host (It can only assume an IAM role). Due to security reasons AWS keys are rotated periodically, but they can be fetched or renewed from instance metadata. |
| Lazy format on Azure | We fixed the issue causing Azure format to be extremely slow when more than 16 disks were attached. |

## Technical Preview

This release includes the following Technical Preview features and improvements:

| Feature | Description |
|----|----|
| Mesos | **Technical Preview** Support for Mesos cloud provider. |
| Kerberos | **Technical Preview** Support for enabling Kerberos on the HDP clusters deployed by Cloudbreak. See [Kerberos](kerberos.md) for more information. |
| Platforms | **Technical Preview** Support for defining Platforms to relate different configurations together. See [Platforms](topologies.md) for more information. |
