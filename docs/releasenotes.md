# Release Notes

The Release Notes summarize and describe changes released in Cloudbreak.

## New Features

This release includes the following new features and improvements:

| Feature | Description |
|----|----|
| Cloudbreak Recipes | Ability to script extensions that run before/after cluster installation. See [Recipes](recipes.md) for more information. |
| Cloudbreak Shell | A Command Line Interface (CLI) for interactively managing Cloudbreak. See [Shell](shell.md) for more information. |
| Cloud Provider SPI | Cloudbreak Service Provider Interface (SPI) for pluging-in new providers. See [SPI](spi.md) for more information. |
| Pre-built Cloud Images | Pre-built Cloud images for AWS, GCP and OpenStack that include Cloudbreak Deployer pre-installed and configured.|
| Azure Resource Manager Template | Pre-build ARM template to install the Cloudbreak Deployer. See [Azure Setup](azure.md) for more information. |
| Azure WASB Support| For clusters launched on Microsoft Azure the default file system in use will be [WASB](http://blogs.msdn.com/b/cindygross/archive/2015/02/04/understanding-wasb-and-hadoop-storage-in-azure.aspx). Users will still have to option to use local HDFS with attached disk but the recommended file system will be WASB. See Filesystem configuration for more information.|
| Azure DASH Support for WASB| When WASB is used as a Hadoop filesystem, the files are full-value blobs in a storage account. It means better performance compared to the data disks and the WASB filesystem can be configured very easily but Azure storage accounts have their own [limitations](https://azure.microsoft.com/en-us/documentation/articles/azure-subscription-service-limits/#storage-limits) as well. There is a space limitation for TB per storage account (500 TB) as well but the real bottleneck is the total request rate that is only 20000 IOPS where Azure will start to throw errors when trying to do an I/O operation. To bypass those limits Microsoft created a small service called [DASH](https://github.com/MicrosoftDX/Dash). See [File system configuration](azure.md#file-system-configuration) for more information. |
| OpenStack | Support for OpenStack Juno and Kilo. See [OpenStack](openstack.md) for more information. |
| New Regions| On AWS we added support for **Frankfurt**. On GCP we added support for **us-east-1**.|
| Custom Security Groups | Ability to define and create custom security groups and rules. |
| Add/Remove Nodes | Introduced the availability to add or remove nodes (arbitrary number) to different hostgroups from the UI. This feature was previousely available from the shell or API only. |
| Auto-scaling | Support for SLA-based [Auto-Scaling](periscope.md). |
| Auto-termination | Automatic termination for unused nodes. |

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
| Cloudbreak Web UI | New cluster create wizard, new cluster details panel, new progress bars for Ambari. |
| UAA zones | Updated to UAA 2.7.1 version, which introduced the concept of **zones**. See [Access from custom domains](configuration.md) for more information.|
| Ambari | Upgraded to Ambari 2.2.1.1. |
| Blueprints | Includes new HDP 2.4 Ambari Blueprints. |


