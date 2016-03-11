## File system configuration

When starting a cluster with Cloudbreak on Azure, the default file system is “Windows Azure Blob Storage”. Hadoop has 
built-in support for the [WASB file system](https://hadoop.apache.org/docs/current/hadoop-azure/index.html) so it can be
used easily as HDFS.

### Disks and blob storage

In Azure every data disk attached to a virtual machine [is stored](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-disks-vhds/) as a virtual hard disk (VHD) in a page blob inside an Azure storage account. Because these are not local disks and the operations must be done on the VHD files it causes degraded performance when used as HDFS.
When WASB is used as a Hadoop file system the files are full-value blobs in a storage account. It means better performance compared to the data disks and the WASB file system can be configured very easily but Azure storage accounts have their own [limitations](https://azure.microsoft.com/en-us/documentation/articles/azure-subscription-service-limits/#storage-limits) as well. There is a space limitation for TB per storage account (500 TB) as well but the real bottleneck is the total request rate that is only 20000 IOPS where Azure will start to throw errors when trying to do an I/O operation.
To bypass those limits Microsoft created a small service called [DASH](https://github.com/MicrosoftDX/Dash). DASH itself is a service that imitates the API of the Azure Blob Storage API and it can be deployed as a Microsoft Azure Cloud Service. Because its API is the same as the standard blob storage API it can be used *almost* in the same way as the default WASB file system from a Hadoop deployment.
DASH works by sharding the storage access across multiple storage accounts. It can be configured to distribute storage account load to at most 15 **scaleout** storage accounts. It needs one more **namespace** storage account where it keeps track of where the data is stored.
When configuring a WASB file system with Hadoop, the only required config entries are the ones where the access details are described. To access a storage account Azure generates an access key that is displayed on the Azure portal or can be queried through the API while the account name is the name of the storage account itself. A DASH service has a similar account name and key, those can be configured in the configuration file while deploying the cloud service.

![](/diagrams/dash.png)

### Deploying a DASH service with Cloudbreak Deployer

We automated the deployment of DASH service in Cloudbreak Deployer. After `cbd` is installed, simply run the 
following command to deploy a DASH cloud service with 5 scale out storage accounts:
```
cbd azure deploy-dash --accounts 5 --prefix dash --location "West Europe" --instances 3
```

The command applies the following steps:

1. It creates the namespace account and the scale out storage accounts
2. It builds the *.cscfg* configuration file based on the created storage account names and keys
3. It generates an Account Name and an Account Key for the DASH service
4. Finally it deploys the cloud service package file to a new cloud service

The WASB file system configured with DASH can be used as a data lake - when multiple clusters are deployed with the 
same DASH file system configuration the same data can be accessed from all the clusters, but every cluster can have a 
different service configured as well. In that case deploy as many DASH services with `cbd` as clusters with 
Cloudbreak and configure them accordingly.

### Containers within the storage account

Cloudbreak creates a new container in the configured storage account for each cluster with the following name 
pattern `cloudbreak-UNIQUE_ID`. Re-using existing containers in the same account is not supported as dirty data can 
lead to failing cluster installations. In order to take advantage of the WASB file system your data does not have to 
be in the same storage account nor in the same container. You can add as many accounts as you wish through Ambari, by
 setting the properties described [here](https://hadoop.apache.org/docs/stable/hadoop-azure/index.html). Once you 
 added the appropriate properties you can use those storage accounts with the pre-existing data, like:
```
hadoop fs -ls wasb://data@youraccount.blob.core.windows.net/terasort-input/
```

> **IMPORTANT** Make sure that your cloud account can launch instances using the new Azure ARM (a.k.a. V2) API and 
you have sufficient qouta (CPU, network, etc) for the requested cluster size.
