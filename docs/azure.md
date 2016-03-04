# Azure Setup

On other cloud providers you can create “public images”, while on Azure its a different process. You have to create a 
publicly available virtual disk image (VHDI), which has to be downloaded and imported 
into a storage account.

Based on our experience usually it takes about 30-60 minutes until it gets copied and you can log into the VM.
Therefore we provide a much easier way to launch Cludbreak Deployer based on the new [Azure Resource Manager 
Templates](https://github.com/Azure/azure-quickstart-templates).

## Deploy using the Azure Portal

It is as simple as clicking here: <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsequenceiq%2Fazure-cbd-quickstart%2Fmaster%2Fazuredeploy.json">  ![deploy on azure](http://azuredeploy.net/deploybutton.png) </a>

**The following parameters are mandatory (beyond to the default values) for the new `cbd` Template!**

On the `Custom deployment` panel:

  * Please create a new `Resource group`
  * Select an appropriate `Resource group location`

On the `Parameters` panel:

  * Select the same `LOCATION` as for the resource group
  * `PASSWORD` must be between 6-72 characters long and must satisfy 
  at least 3 of password complexity requirements from the following:
    * Contains an uppercase character
    * Contains a lowercase character
    * Contains a numeric digit
    * Contains a special character

**Finally** you should review the `Legal terms` from the `Custom deployment` panel:

  * If you agree with the terms and conditions, just click on `Create` 
button of this panel
  * Also click on the `Create` button on the `Custom deployment` 

> Deployment takes about **15-20 minutes**. You can track the 
progress on the resource group details. If any issue has occurred, open the `Audit logs` from the settings. 
> We have faced an interesting behaviour on the Azure Portal: [All operations were successful on template deployment, 
but overall fail](https://github.com/Azure/azure-quickstart-templates/issues/1294).

  * Once it's successful done, you can reach the Cloudbreak UI 
at:```http://<VM Public IP>:3000/```
    * email: admin@example.com
    * password: cloudbreak

**Optional**

You can SSH to the VM and track the progress in the Cloudbreak logs as well:
```
cbd logs cloudbreak
```
  * Cloudbreak Deployer location is `/var/lib/cloudbreak-deployment`.
  * All `cbd` actions must be executed from the `cbd` folder.
  * Most of the `cbd` commands require `root` permissions.

For example to investigate the Cloudbreak logs:
```
cloudbreak@cbdeployerVM:/var/lib/cloudbreak-deployment# cbd logs cloudbreak
```
>You should see a line like the following one in the logs: 
`Started CloudbreakApplication in 187.791 seconds (JVM running for 202.127)`

After the Cloudbreak Deployer has started the following is worthy to check:
```
cbd doctor
```

>In case of cbd update is needed, please check the related documentation for [Cloudbreak Deployer Update](operations.md#cloudbreak-deployer-update)

## Under the hood

Meanwhile Azure is creating the deployment, here is some information about what happens in the background:

  * Start an instance from the official CentOS image
    * So no custom image copy is needed, which would take about 30 
   minutes
  * Use [Docker VM Extension](https://github.com/Azure/azure-docker-extension) to install Docker
  * Use [CustomScript Extension](https://github.com/Azure/azure-linux-extensions/tree/master/CustomScript) to install 
Cloudbreak Deployer (`cbd`)

# Provisioning Prerequisites

We use the new [Azure ARM](https://azure.microsoft.com/en-us/documentation/articles/resource-group-overview/) in 
order to launch clusters. In order to work we need to create an **Active Directory** application with the configured name and password and adds the permissions that are needed to call the Azure Resource Manager API. Cloudbreak Deployer automates all this for you.

## Generate a new SSH key

All the instances created by Cloudbreak are configured to allow key-based SSH,
so you'll need to provide an SSH public key that can be used later to SSH onto the instances in the clusters you'll create with Cloudbreak.
You can use one of your existing keys or you can generate a new one.

To generate a new SSH keypair:

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
# Creates a new ssh key, using the provided email as a label
# Generating public/private rsa key pair.
```

```
# Enter file in which to save the key (/Users/you/.ssh/id_rsa): [Press enter]
You'll be asked to enter a passphrase, but you can leave it empty.

# Enter passphrase (empty for no passphrase): [Type a passphrase]
# Enter same passphrase again: [Type passphrase again]
```

After you enter a passphrase the keypair is generated. The output should look something like below.
```
# Your identification has been saved in /Users/you/.ssh/id_rsa.
# Your public key has been saved in /Users/you/.ssh/id_rsa.pub.
# The key fingerprint is:
# 01:0f:f4:3b:ca:85:sd:17:sd:7d:sd:68:9d:sd:a2:sd your_email@example.com
```

Later you'll need to pass the `.pub` file's contents to Cloudbreak and use the private part to SSH to the instances.

## Azure access setup

If you do not have an **Active Directory (AD)** user then you have to configure it before deploying a cluster with 
Cloudbreak:

 - Go to `manage.windowsazure.com` > `Active Directory`
 - Select one of your AD where you would like to create the new user
 - You can configure your AD users on `Your active directory` > `Users` menu

![](/images/azure-aduser_v2.png)
<sub>*Full size [here](/images/azure-aduser_v2.png).*</sub>

 - Here you can add the new user to AD. Simply click on `Add User` in the bottom of the page
    * `TYPE OF USER`: select `New user in your organization`
    * `USER NAME`: type the new user name into the box
    * Fill out the name fields for the new user on the second page of the ADD USER window
    * Submit the new user creation on the third window with the big green button
    * Copy the password `Folo4965`
    * Click on the tick button in the bottom of the the ADD USER window
 - You will see the new user in the `USERS` list

>You have got a temporary password so you have to change it before you start using the new user.

 - You need to add your AD user to the `manage.windowsazure.com` > `Settings` > `Administrators`

![](/images/azure-administrators_v2.png)
<sub>*Full size [here](/images/azure-administrators_v2.png).*</sub>

 - Here you can add the new user to Administrators. Simply click on `Add` in the bottom of the page
    * `EMAIL ADDRESS`: copy the previously created user email address here
    * Select the appropriate `SUBSCRIPTION` for the user
    * Click on the tick button in the bottom of the the ADD A CO-ADMINISTRATOR window
 - You will see the new co-administrator a in the `ADMINISTRATORS` list

## Azure application setup with Cloudbreak Deployer

In order for Cloudbreak to be able to launch clusters on Azure on your behalf you need to set up your **Azure ARM 
application**. If you do not want to create your ARM application via the Azure Web UI, **we automated the related Azure 
configurations in the Cloudbreak Deployer**.

If you use our [Azure Template for Cloudbreak Deployer](azure.md#deploy-using-the-azure-portal), you should:

  * SSH to the Cloudbreak Deployer Virtual machine
  * `cbd` location is `/var/lib/cloudbreak-deployment`
  * all `cbd` actions must be executed from the `cbd` folder

> Most of the `cbd` commands require `root` permissions. **So `sudo su` here would be worth for you.**

You can setup your Azure Application with the following `cbd` command:

```
cbd azure configure-arm --app_name myapp --app_password password123 --subscription_id 1234-abcd-efgh-1234
```
Other available options:

`--app_name` your new application name, *app* by default

`--app_password` your application password, *password* by default

`--subscription_id` your Azure subscription ID

`--username` your Azure username

`--password` your Azure password

The command applies the following steps:

1. It creates an Active Directory application with the configured name, password
2. It grants permissions to call the Azure Resource Manager API

**Please use the output of the command when you creating your Azure credential in Cloudbreak.** The major part of 
the output should be like this example:

```
Subscription ID: sdf324-26b3-sdf234-ad10-234dfsdfsd
App ID: 234sdf-c469-sdf234-9062-dsf324
Password: password123
App Owner Tenant ID: sdwerwe1-d98e-dsf12-dsf123-df123232
```

## Filesystem configuration

When starting a cluster with Cloudbreak on Azure, the default filesystem is “Windows Azure Blob Storage”. Hadoop has 
built-in support for the [WASB filesystem](https://hadoop.apache.org/docs/current/hadoop-azure/index.html) so it can be
used easily as HDFS.

### Disks and blob storage

In Azure every data disk attached to a virtual machine [is stored](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-disks-vhds/) as a virtual hard disk (VHD) in a page blob inside an Azure storage account. Because these are not local disks and the operations must be done on the VHD files it causes degraded performance when used as HDFS.
When WASB is used as a Hadoop filesystem the files are full-value blobs in a storage account. It means better performance compared to the data disks and the WASB filesystem can be configured very easily but Azure storage accounts have their own [limitations](https://azure.microsoft.com/en-us/documentation/articles/azure-subscription-service-limits/#storage-limits) as well. There is a space limitation for TB per storage account (500 TB) as well but the real bottleneck is the total request rate that is only 20000 IOPS where Azure will start to throw errors when trying to do an I/O operation.
To bypass those limits Microsoft created a small service called [DASH](https://github.com/MicrosoftDX/Dash). DASH itself is a service that imitates the API of the Azure Blob Storage API and it can be deployed as a Microsoft Azure Cloud Service. Because its API is the same as the standard blob storage API it can be used *almost* in the same way as the default WASB filesystem from a Hadoop deployment.
DASH works by sharding the storage access across multiple storage accounts. It can be configured to distribute storage account load to at most 15 **scaleout** storage accounts. It needs one more **namespace** storage account where it keeps track of where the data is stored.
When configuring a WASB filesystem with Hadoop, the only required config entries are the ones where the access details are described. To access a storage account Azure generates an access key that is displayed on the Azure portal or can be queried through the API while the account name is the name of the storage account itself. A DASH service has a similar account name and key, those can be configured in the configuration file while deploying the cloud service.

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

The WASB filesystem configured with DASH can be used as a data lake - when multiple clusters are deployed with the 
same DASH filesystem configuration the same data can be accessed from all the clusters, but every cluster can have a 
different service configured as well. In that case deploy as many DASH services with `cbd` as clusters with 
Cloudbreak and configure them accordingly.

### Containers within the storage account

Cloudbreak creates a new container in the configured storage account for each cluster with the following name 
pattern `cloudbreak-UNIQUE_ID`. Re-using existing containers in the same account is not supported as dirty data can 
lead to failing cluster installations. In order to take advantage of the WASB filesystem your data does not have to 
be in the same storage account nor in the same container. You can add as many accounts as you wish through Ambari, by
 setting the properties described [here](https://hadoop.apache.org/docs/stable/hadoop-azure/index.html). Once you 
 added the appropriate properties you can use those storage accounts with the pre-existing data, like:
```
hadoop fs -ls wasb://data@youraccount.blob.core.windows.net/terasort-input/
```

> **IMPORTANT** Make sure that your cloud account can launch instances using the new Azure ARM (a.k.a. V2) API and 
you have sufficient qouta (CPU, network, etc) for the requested cluster size.

#Provisioning via Browser

You can log into the Cloudbreak application at `http://<Public_IP>:3000/`.

The main goal of the Cloudbreak UI is to easily create clusters on your own cloud provider account.
This description details the AZURE setup - if you'd like to use a different cloud provider check out its manual.

This document explains the four steps that need to be followed to create Cloudbreak clusters from the UI:

- connect your AZURE account with Cloudbreak
- create some template resources on the UI that describe the infrastructure of your clusters
- create a blueprint that describes the HDP services in your clusters and add some recipes for customization
- launch the cluster itself based on these template resources

## Setting up Azure credentials

Cloudbreak works by connecting your AZURE account through so called *Credentials*, and then uses these credentials to 
create resources on your behalf. The credentials can be configured on the **manage credentials** panel on the 
Cloudbreak Dashboard.

>Please read the [Provisioning prerequisites](azure.md#azure-application-setup-with-cloudbreak-deployer) where you 
can find the steps how can get the mandatory `Subscription ID`, `App ID`, `Password` and `App Owner Tenant ID` for 
your Cloudbreak credential.

To create a new AZURE credential follow these steps:

  - Fill out the new credential `name`
    * Only alphanumeric and lowercase characters (min 5, max 100 characters) can be applied
  - Copy your AZURE Subscription ID to the `Subscription Id` field

![](/images/azure-subscription.png)
<sub>*Full size [here](/images/azure-subscription.png).*</sub>

  - Copy your AZURE Active Directory Application:
    * ID to the `App Id` field
    * password to the `Password` field
    * `App Owner Tenant Id` field

![](/images/azure-application.png)
<sub>*Full size [here](/images/azure-application.png).*</sub>

  - Copy your SSH public key to the `SSH public key` field
    * The SSH public key must be in OpenSSH format and it's private keypair can be used later to [SSH onto every 
    instance](operations.md#ssh-to-the-hosts) of every cluster you'll create with this credential.
    - The **SSH username** for the AZURE instances is **cloudbreak**.

>Any other parameter is optional here.

>`Public in account` means that all the users belonging to your account will be able to use this credential to create 
clusters, but cannot delete it.

> Cloudbreak is supporting simple rsa public key instead of X509 certificate file after 1.0.4 version

![](/images/azure-credentials.png)
<sub>*Full size [here](/images/azure-credentials.png).*</sub>

## Infrastructure templates

After your AZURE account is linked to Cloudbreak you can start creating resource templates that describe your clusters' 
infrastructure:

- templates
- networks
- security groups

When you create one of the above resource, **Cloudbreak does not make any requests to AZURE. Resources are only created
 on AZURE after the `create cluster` button has pushed.** These templates are saved to Cloudbreak's database and can be 
 reused with multiple clusters to describe the infrastructure.

**Templates**

Templates describe the **instances of your cluster** - the instance type and the attached volumes. A typical setup is
 to combine multiple templates in a cluster for the different types of nodes. For example you may want to attach multiple
 large disks to the datanodes or have memory optimized instances for Spark nodes.

The instance templates can be configured on the **manage templates** panel on the Cloudbreak Dashboard.

If `Public in account`is checked all the users belonging to your account will be able to use this resource to create 
clusters, but cannot delete it.

**Networks**

Your clusters can be created in their own **Virtual Private Cloud (VPC)** or in one of your already existing VPCs.
If you choose an existing VPC it is possible to create a new subnet within the VPC or use an already existing one.
The subnet's IP range must be defined in the `Subnet (CIDR)` field using the general CIDR notation.

*Default AZURE Network*

If you don't want to create or use your custom VPC, you can use the `default-azure-network` for all your 
Cloudbreak clusters. It will create a new VPC with a `10.0.0.0/16` subnet every time a cluster is created.

*Custom AZURE Network*

If you'd like to deploy a cluster to a custom VPC you'll have to **create a new network** template on the **manage 
networks** panel. You can configure the `Subnet Identifier` and the `Virtual Network Identifier` of your VPC.

>**IMPORTANT** The subnet CIDR cannot overlap each other in a VPC. So you have to create different network 
templates for every each clusters.

To create a new subnet within the VPC, provide the ID of the subnet which is in the existing VPC and your cluster 
will be launched into that subnet. **For example** you can create 3 different clusters with 3 different network 
templates for multiple subnets `10.0.0.0/24`, `10.0.1.0/24`, `10.0.2.0/24` with the same VPC and Virtual Network 
Identifiers.

>**IMPORTANT** Please make sure the define subnet here doesn't overlap with any of your already deployed subnet in 
the VPC, because of the validation only happens after the cluster creation starts.

>In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

If `Public in account` is checked all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

>**NOTE** The VPCs, Virtual Network identifiers and subnet are created on AZURE only after the the cluster 
provisioning starts with the selected network template.

![](/images/azure-network.png)
<sub>*Full size [here](/images/azure-network.png).*</sub>




Manage networks allows you to create or reuse existing networks and configure them.

`Name:` name of the network

`Description:` short description of your network

`Subnet (CIDR):` a subnet in the VPC with CIDR block

`Address prefix (CIDR):` the address space that is used for subnets

Optional parameters (reuse existing network and subnet, in this case all 3 parameters must be provided as well, changes the security group's behavior described in security group section):

`Resource Group Identifier:` name of an existing resource group which is used in case of existing virtual network and subnet

`Virtual Network Identifier:` name of the virutal network within the selected resource group

`Subnet Identifier:` name of the subnet within the selected virtual network (the provided subnet CIDR will be ignored and the existing subnet's CIDR range will be used)

`Public in account:` share it with others in the account

**Security groups**

They describe the allowed inbound traffic to the instances in the cluster.
Currently only one security group template can be selected for a Cloudbreak cluster and all the instances have a public IP address so all the instances in the cluster will belong to the same security group. If you choose to deploy your cluster into and existing network and subnet the security group won't be created, because only 1 security group can be assigned to a subnet. However the security rules defined in the selected security group will be applied to the gateway instance.
This may change in a later release.

You can define your own security group by adding all the ports, protocols and CIDR range you'd like to use. 443 needs to be there in every security group otherwise Cloudbreak won't be able to communicate with the provisioned cluster. The rules defined here doesn't need to contain the internal rules, those are automatically added by Cloudbreak to the security group on Azure.

You can also use the two pre-defined security groups in Cloudbreak:

`only-ssh-and-ssl:` all ports are locked down except for SSH and gateway HTTPS (you can't access Hadoop services outside of the VPC):

* SSH (22)
* HTTPS (443)

`all-services-port:` all Hadoop services and SSH/gateway HTTPS are accessible by default:

* SSH (22)
* HTTPS (443)
* Ambari (8080)
* Consul (8500)
* NN (50070)
* RM Web (8088)
* Scheduler (8030RM)
* IPC (8050RM)
* Job history server (19888)
* HBase master (60000)
* HBase master web (60010)
* HBase RS (16020)
* HBase RS info (60030)
* Falcon (15000)
* Storm (8744)
* Hive metastore (9083)
* Hive server (10000)
* Hive server HTTP (10001)
* Accumulo master (9999)
* Accumulo Tserver (9997)
* Atlas (21000)
* KNOX (8443)
* Oozie (11000)
* Spark HS (18080)
* NM Web (8042)
* Zeppelin WebSocket (9996)
* Zeppelin UI (9995)
* Kibana (3080)
* Elasticsearch (9200)

If `Public in account` is checked all the users belonging to your account will be able to use this security group template to create clusters, but cannot delete or modify it.

>**NOTE** that the security groups are *not created* on AZURE after the `Create Security Group` button is pushed, only 
after the cluster provisioning starts with the selected security group template.

## Defining cluster services

**Blueprints**

Blueprints are your declarative definition of a Hadoop cluster.

`Name:` name of your blueprint

`Description:` short description of your blueprint

`Source URL:` you can add a blueprint by pointing to a URL. As an example you can use this [blueprint](https://raw.githubusercontent.com/sequenceiq/cloudbreak/master/core/src/main/resources/defaults/blueprints/multi-node-hdfs-yarn.bp).

`Manual copy:` you can copy paste your blueprint in this text area

`Public in account:` share it with others in the account


## Cluster installation

This section describes

**Blueprints**

Blueprints are your declarative definition of a Hadoop cluster. These are the same blueprints that are [used by Ambari](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints).

You can use the 3 default blueprints pre-defined in Cloudbreak or you can create your own.
Blueprints can be added from an URL or the whole JSON can be copied to the `Manual copy` field.

The hostgroups added in the JSON will be mapped to a set of instances when starting the cluster and the services and components defined in the hostgroup will be installed on the corresponding nodes.
It is not necessary to define all the configuration fields in the blueprints - if a configuration is missing, Ambari will fill that with a default value.
The configurations defined in the blueprint can also be modified later from the Ambari UI.

If `Public in account` is checked all the users belonging to your account will be able to use this blueprint to create clusters, but cannot delete or modify it.

A blueprint can be exported from a running Ambari cluster that can be reused in Cloudbreak with slight modifications.
There is no automatic way to modify an exported blueprint and make it instantly usable in Cloudbreak, the modifications have to be done manually.
When the blueprint is exported some configurations will have for example hardcoded domain names, or memory configurations that won't be applicable to the Cloudbreak cluster.

**Cluster customization**

Sometimes it can be useful to define some custom scripts that run during cluster creation and add some additional functionality.
For example it can be a service you'd like to install but it's not supported by Ambari or some script that automatically downloads some data to the necessary nodes.
The most notable example is Ranger setup: it has a prerequisite of a running database when Ranger Admin is installing.
A PostgreSQL database can be easily started and configured with a recipe before the blueprint installation starts.

To learn more about these so called *Recipes*, and to check out the Ranger database recipe, take a look at the [Cluster customization](recipes.md) part of the documentation.


## Cluster deployment

After all the templates are configured you can deploy a new HDP cluster. Start by selecting a previously created credential in the header.
Click on `create cluster`, give it a `Name`, select a `Region` where the cluster infrastructure will be provisioned and select one of the `Networks` and `Security Groups` created earlier.
After you've selected a `Blueprint` as well you should be able to configure the `Template resources` and the number of nodes for all of the hostgroups in the blueprint.

If `Public in account` is checked all the users belonging to your account will be able to see the newly created cluster on the UI, but cannot delete or modify it.

If `Enable security` is checked as well, Cloudbreak will install KDC and the cluster will be Kerberized. See more about it in the [Kerberos](kerberos.md) section of this documentation.

After the `create and start cluster` button is pushed Cloudbreak will start to create resources on your AZURE account.
Cloudbreak uses *ARM template* to create the resources - you can check out the resources created by Cloudbreak on the [ARM Portal](https://portal.azure.com) on the 'Resource groups' page.

>**IMPORTANT** Always use Cloudbreak to delete the cluster, or if that fails for some reason always try to delete 
the ARM first.

**Advanced options**

There are some advanced features when deploying a new cluster, these are the following:

`File system:` read more Deploying a DASH service with Cloudbreak Deployer in the preprovisioning section

`Minimum cluster size:` the provisioning strategy in case of the cloud provider can't allocate all the requested nodes

`Validate blueprint:` feature to validate or not the Ambari blueprint. By default is switched on.

`Config recommendation strategy:` Specifies the strategy for how configuration recommendations may be applied to a cluster’s configuration. Recommended configurations gathered by the response of the stack advisor. 

* `NEVER_APPLY:`               Configuration recommendations are ignored with this option.
* `ONLY_STACK_DEFAULTS_APPLY:` Applies only on the default configurations for all included services.
* `ALWAYS_APPLY:`              Applies on all configuration properties.

Congrats! Your cluster should now be up and running. To learn more about it we have some [interesting insights](operations.md) about Cloudbreak clusters.

## Cluster termination

You can terminate running or stopped clusters with the `terminate` button in the cluster details.

Sometimes Cloudbreak cannot synchronize it's state with the cluster state at the cloud provider and the cluster can't be terminated. In this case with the `Forced termination` option in the termination dialog box you can terminate the cluster at the Cloudbreak side anyway. **In this case you may need to manually remove resources at the cloud provider.**

# Interactive mode

Start the shell with `cbd util cloudbreak-shell`. This will launch the Cloudbreak Shell inside a Docker container and you are ready to start using it.

You have to copy files into the `cbd` working directory, which you would like to use from shell. For example if your `cbd` working directory is `~/prj/cbd` then copy your blueprint and public ssh key file into this directory. You can refer to these files with their names from the shell.

### Create a cloud credential

```
credential create --AZURE --description "credential description" --name myazurecredential --subscriptionId <your Azure subscription id> --appId <your Azure application id> --tenantId <your tenant id> --password <your Azure application password> --sshKeyPath <path of your public SSH key file>
```

> Cloudbreak is supporting simple rsa public key instead of X509 certificate file after 1.0.4 version

Alternatively you can upload your public key from an url as well, by using the `—sshKeyUrl` switch, or use the ssh string with `—sshKeyString` switch. You can check whether the credential was creates successfully by using the `credential list` command.
You can switch between your cloud credential - when you’d like to use one and act with that you will have to use:
```
credential select --name myazurecredential
```

You can delete your cloud credential - when you’d like to delete one you will have to use:
```
credential delete --name myazurecredential
```

You can show your cloud credential - when you’d like to show one you will have to use:
```
credential show --name myazurecredential
```

### Create a template

A template gives developers and systems administrators an easy way to create and manage a collection of cloud infrastructure related resources, maintaining and updating them in an orderly and predictable fashion. A template can be used repeatedly to create identical copies of the same stack (or to use as a foundation to start a new stack).

```
template create --AZURE --name azuretemplate --description azure-template --instanceType STANDARD_D3 --volumeSize 100 --volumeCount 2
```
You can check whether the template was created successfully by using the `template list` or `template show` command.

You can delete your cloud template - when you’d like to delete one you will have to use:
```
template delete --name azuretemplate
```

### Create or select a blueprint

You can define Ambari blueprints with cloudbreak-shell:

```
blueprint add --name myblueprint --description myblueprint-description --file <the path of the blueprint>
```

Other available options:

`--url` the url of the blueprint

`--publicInAccount` flags if the network is public in the account

We ship default Ambari blueprints with Cloudbreak. You can use these blueprints or add yours. To see the available blueprints and use one of them please use:

```
blueprint list

blueprint select --name hdp-small-default
```

### Create a network

A network gives developers and systems administrators an easy way to create and manage a collection of cloud infrastructure related networking, maintaining and updating them in an orderly and predictable fashion. A network can be used repeatedly to create identical copies of the same stack (or to use as a foundation to start a new stack).

```
network create --AZURE --name azurenetwork --description azure-network --subnet 10.0.0.0/16 --addressPrefix 10.0.0.0/8
```

Other available options:

`--publicInAccount` flags if the network is public in the account

There is a default network with name `default-azure-network` with 10.0.0.0/16 subnet and 10.0.0.0/8 addressPrefix.

You can check whether the network was created successfully by using the `network list` command. Check the network and select it if you are happy with it:

```
network show --name azurenetwork

network select --name azurenetwork
```

### Create a security group

A security group gives developers and systems administrators an easy way to create and manage a collection of cloud infrastructure related security rules.

```
securitygroup create --name secgroup_example --description securitygroup-example --rules 0.0.0.0/0:tcp:8080,9090;10.0.33.0/24:tcp:1234,1235
```

You can check whether the security group was created successfully by using the `securitygroup list` command. Check the security group and select it if you are happy with it:

```
securitygroup show --name secgroup_example

securitygroup select --name secgroup_example
```

There are two default security groups defined: `all-services-port` and `only-ssh-and-ssl`

`only-ssh-and-ssl:` all ports are locked down (you can't access Hadoop services outside of the VPC)

* SSH (22)
* HTTPS (443)

`all-services-port:` all Hadoop services + SSH/HTTP are accessible by default:

* SSH (22)
* HTTPS (443)
* Ambari (8080)
* Consul (8500)
* NN (50070)
* RM Web (8088)
* Scheduler (8030RM)
* IPC (8050RM)
* Job history server (19888)
* HBase master (60000)
* HBase master web (60010)
* HBase RS (16020)
* HBase RS info (60030)
* Falcon (15000)
* Storm (8744)
* Hive metastore (9083)
* Hive server (10000)
* Hive server HTTP (10001)
* Accumulo master (9999)
* Accumulo Tserver (9997)
* Atlas (21000)
* KNOX (8443)
* Oozie (11000)
* Spark HS (18080)
* NM Web (8042)
* Zeppelin WebSocket (9996)
* Zeppelin UI (9995)
* Kibana (3080)
* Elasticsearch (9200)

### Configure instance groups

You have to configure the instancegroups before the provisioning. An instancegroup is defining a group of your nodes with a specified template. Usually we create instancegroups for the hostgroups defined in the blueprints.

```
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName minviable-azure
```

Other available options:

`--templateId` Id of the template

### Create a Hadoop cluster
You are almost done - two more command and this will create your Hadoop cluster on your favorite cloud provider. Same as the API, or UI this will use your `credential`, `instancegroups`, `network`, `securitygroup`, and by using Azure ResourceManager will launch a cloud stack
```
stack create --name my-first-stack --region WEST_US
```
Once the `stack` is up and running (cloud provisioning is done) it will use your selected `blueprint` and install your custom Hadoop cluster with the selected components and services.
```
cluster create --description "my first cluster"
```
You are done - you can check the progress through the Ambari UI. If you log back to Cloudbreak UI you can check the progress over there as well, and learn the IP address of Ambari.

### Stop/Restart cluster and stack
You have the ability to **stop your existing stack then its cluster** if you want to suspend the work on it.

Select a stack for example with its name:
```
stack select --name my-stack
```
Other available option to define a stack is its `--id` (instead of the `--name`).

Apply the following commands to stop the previously selected stack:
```
cluster stop
stack stop
```
>**IMPORTANT!** The related cluster should be stopped before you can stop the stack.


Apply the following command to **restart the previously selected and stopped stack**:
```
stack start
```
After the selected stack has restarted, you can **restart the related cluster as well**:
```
cluster start
```

### Upscale/Downscale cluster and stack
You can **upscale your selected stack** if you need more instances to your infrastructure:
```
stack node --ADD --instanceGroup host_group_slave_1 --adjustment 6
```
Other available options:

`--withClusterUpScale` indicates cluster upscale after stack upscale
or you can upscale the related cluster separately as well:
```
cluster node --ADD --hostgroup host_group_slave_1 --adjustment 6
```


Apply the following command to **downscale the previously selected stack**:
```
stack node --REMOVE  --instanceGroup host_group_slave_1 --adjustment -2
```
and the related cluster separately:
```
cluster node --REMOVE  --hostgroup host_group_slave_1 --adjustment -2
```

## Silent mode

With Cloudbreak Shell you can execute script files as well. A script file contains cloudbreak shell commands and can be executed with the `script` cloudbreak shell command

```
script <your script file>
```

or with the `cbd util cloudbreak-shell-quiet` `cbd` command:

```
cbd util cloudbreak-shell-quiet < example.sh
```

## Example

The following example creates a hadoop cluster with `hdp-small-default` blueprint on STANDARD_D3 instances with 2X100G attached disks on `default-azure-network` network using `all-services-port` security group. You should copy your ssh public key file into your `cbd` working directory with name `id_rsa.pub` and change the `<...>` parts with your azure credential details.

```
credential create --AZURE --description "credential description" --name myazurecredential --subscriptionId <your Azure subscription id> --appId <your Azure application id> --tenantId <your tenant id> --password <your Azure application password> --sshKeyPath id_rsa.pub
credential select --name myazurecredential
template create --AZURE --name azuretemplate --description azure-template --instanceType STANDARD_D3 --volumeSize 100 --volumeCount 2
blueprint select --name hdp-small-default
instancegroup configure --instanceGroup cbgateway --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_master_1 --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_master_2 --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_master_3 --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_client_1  --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName azuretemplate
network select --name default-azure-network
securitygroup select --name all-services-port
stack create --name my-first-stack --region WEST_US
cluster create --description "My first cluster"
```

Congrats! Your cluster should now be up and running. To learn more about it we have some [interesting insights](operations.md) about Cloudbreak clusters.