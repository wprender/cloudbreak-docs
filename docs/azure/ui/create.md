**Cluster customization**

Sometimes it can be useful to **define some custom scripts so called Recipes in Cloudbreak** that run during cluster 
creation and add some additional functionality.

For example it can be a service you'd like to install but it's not supported by Ambari or some script that 
automatically downloads some data to the necessary nodes.
The most **notable example is Ranger setup**:

- It has a prerequisite of a running database when Ranger Admin is installing.
- A PostgreSQL database can be easily started and configured with a recipe before the blueprint installation starts.

To learn more about these and check the Ranger recipe out, take a look at the [Cluster customization](recipes.md).

## Cluster deployment

After all the cluster resources are configured you can deploy a new HDP cluster.

Here is a **basic flow for cluster creation on Cloudbreak Web UI**:

 - Start by selecting a previously created Azure credential in the header.

![](/images/ui-credentials_v2.png)
<sub>*Full size [here](/images/ui-credentials_v2.png).*</sub>

 - Open `create cluster`

`Configure Cluster` tab

 - Fill out the new cluster `name`
    - Cluster name must start with a lowercase alphabetic character then you can apply lowercase alphanumeric and 
   hyphens only (min 5, max 40 characters)
 - Select a `Region` where you like your cluster be provisioned
 - Click on the `Setup Network and Security` button
>If `Public in account` is checked all the users belonging to your account will be able to see the created cluster on
 the UI, but cannot delete or modify it.

`Setup Network and Security` tab

 - Select one of the networks
 - Select one of the security groups
 - Click on the `Choose Blueprint` button
>If `Enable security` is checked as well, Cloudbreak will install Key Distribution Center (KDC) and the cluster will 
be Kerberized. See more about it in the [Kerberos](kerberos.md) section of this documentation.

`Choose Blueprint` tab

 - Select one of the blueprint
 - After you've selected a `Blueprint`, you should be able to configure:
    - the templates
    - the number of nodes for all of the host groups in the blueprint
    - the recipes for nodes
 - Click on the `Add File System` button

`Add File System` tab

 - Select one of the file system that fits your needs
 - After you've selected `WASB` or `DASH`, you should configure:
    - `Storage Account Name`
    - `Storage Account Access Key`
 - Click on the `Review and Launch` button
>`File system` is a mandatory configuration for Azure. You can read more about WASB and DASH in the [File System Configuration section](azure.md#file-system-configuration).

`Review and Launch` tab

 - After the `create and start cluster` button has clicked Cloudbreak will start to create the cluster's resources on 
 your Azure account.

Cloudbreak uses *Azure Resource Manager* to create the resources - you can check out the resources created by Cloudbreak
 on 
the `Azure Portal Resource groups` page.
![](/azure/images/azure-resourcegroup.png)
<sub>*Full size [here](/azure/images/azure-resourcegroup.png).*</sub>

Besides these you can check the progress on the Cloudbreak Web UI itself if you open the new cluster's `Event History`.
![](/azure/images/azure-eventhistory.png)
<sub>*Full size [here](/azure/images/azure-eventhistory.png).*</sub>

**Advanced options**

There are some advanced features when deploying a new cluster, these are the following:

`Minimum cluster size` The provisioning strategy in case of the cloud provider cannot allocate all the requested nodes.

`Validate blueprint` This is selected by default. Cloudbreak validates the Ambari blueprint in this case.

`Relocate docker` This is selected by default. In startup time the `/var/lib/docker` will be relocated to the temporarily attached SSD. (In this case please do not stop your machines on Azure UI because then your data will be lost)

`Shipyard enabled cluster` This is selected by default. Cloudbreak will start a [Shipyard](https://shipyard-project.com/) container which helps you to manage your containers.

`Persistent Storage Name` This is `cbstore` by default. Cloudbreak will copy the image into a storage which is not deleting under the termination. When you starting a new cluster then the provisioning will be much faster because of the existing image.

`Attached Storage Type` This is `single storage for all vm` by default. If you using the default option then your whole cluster will by in one storage which could be a bottleneck in case of [Azure](https://azure.microsoft.com/hu-hu/documentation/articles/azure-subscription-service-limits/#storage-limits). If you are using the `separated storage for every vm` then we will deploy as much storage account as many node you have and in this case IOPS limit concern just for one node.

`Config recommendation strategy` Strategy for configuration recommendations how will be applied. Recommended 
configurations gathered by the response of the stack advisor. 

* `NEVER_APPLY`               Configuration recommendations are ignored with this option.
* `ONLY_STACK_DEFAULTS_APPLY` Applies only on the default configurations for all included services.
* `ALWAYS_APPLY`              Applies on all configuration properties.

`Start LDAP and configure SSSD` Enables the [System Security Services Daemon](sssd.md) configuration.
