## Cluster deployment

After all the cluster resources are configured you can deploy a new HDP cluster.

Here is a **basic flow for cluster creation on Cloudbreak Web UI**:

 - Start by selecting a previously created AWS credential in the header.

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
 - You need to select where you want to install the Ambari server to. Only 1 host group can be selected.
   If you want to install the Ambari server to a separate node, you need to extend your blueprint with a new host group
   which contains only 1 service: HDFS_CLIENT and select this host group for the Ambari server. Note: this host group cannot be scaled so 
   it is not advised to select a 'slave' host group for this purpose.
 - Click on the `Review and Launch` button

`Review and Launch` tab

 - After the `create and start cluster` button has clicked Cloudbreak will start to create the cluster's resources on 
 your AWS account.

Cloudbreak uses *CloudFormation* to create the resources - you can check out the resources created by Cloudbreak on 
the AWS Console CloudFormation page.
![](/aws/images/aws-cloudformation_v2.png)
<sub>*Full size [here](/aws/images/aws-cloudformation_v2.png).*</sub>

Besides these you can check the progress on the Cloudbreak Web UI itself if you open the new cluster's `Event History`.
![](/images/ui-eventhistory_v3.png)
<sub>*Full size [here](/images/ui-eventhistory_v3.png).*</sub>

**Advanced options**

There are some advanced features when deploying a new cluster, these are the following:

`Availability Zone` You can restrict the instances to a [specific availability zone](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html). It may be useful if you're using
 reserved instances.

`Use dedicated instances` You can use [dedicated instances](https://aws.amazon.com/ec2/purchasing-options/dedicated-instances/) on EC2

`Minimum cluster size` The provisioning strategy in case of the cloud provider cannot allocate all the requested nodes.

`Validate blueprint` This is selected by default. Cloudbreak validates the Ambari blueprint in this case.

`Shipyard enabled cluster` This is selected by default. Cloudbreak will start a [Shipyard](https://shipyard-project.com/) container which helps you to manage your containers.

`Config recommendation strategy` Strategy for configuration recommendations how will be applied. Recommended 
configurations gathered by the response of the stack advisor. 

* `NEVER_APPLY`               Configuration recommendations are ignored with this option.
* `ONLY_STACK_DEFAULTS_APPLY` Applies only on the default configurations for all included services.
* `ALWAYS_APPLY`              Applies on all configuration properties.

`Start LDAP and configure SSSD` Enables the [System Security Services Daemon](sssd.md) configuration.

`Seamless S3 Access` Cluster will be able to reach S3 buckets without any configuration.

* `Disable S3 Access By Default`               Cluster will not be able to reach S3 buckets.
* `Create Role For S3 Access`                  The Cloudformation template will create a new role and assign to every instance.
* `Define Existing Role For S3 Access`         Cluster will use the predefined instance role. You should define the role in the `Role for S3 connection` box.