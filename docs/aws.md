# AWS Cloud Images

We have pre-built cloud images for AWS with the Cloudbreak Deployer pre-installed. You can launch the latest Cloudbreak Deployer image based on your region at the [AWS Management Console](https://aws
.amazon.com/console/).

> Alternatively, instead of using the pre-built cloud images for AWS, you can install Cloudbreak Deployer on your own
 VM. See [installation page](onprem.md) for more information.

Make sure you opened the following ports on your security group:
 
 * SSH (22)
 * Cloudbreak API (8080)
 * Identity server (8089)
 * Cloudbreak GUI (3000)
 * User authentication (3001)

## Cloudbreak Deployer AWS Image Details

> **[Minimum and Recommended VM requirements](onprem.md#minimum-and-recommended-system-requirements):** 4GB RAM, 10GB disk, 2 cores

# AWS Setup

## Setup Cloudbreak Deployer

Open the `cloudbreak-deployment` directory:

```
cd cloudbreak-deployment
```

This is the directory of the configuration files and the supporting binaries for Cloudbreak Deployer.

### Initialize your Profile

```
cbd init
```

It will create a `Profile` file in the current directory. Please open the `Profile` file then check the `PUBLIC_IP`. 
This is mandatory, because of to can access the Cloudbreak UI (called Uluwatu). In some cases the `cbd` tool tries to 
guess it. If `cbd` cannot get the IP address during the initialization, please add set the appropriate value.

### AWS Specific Configuration

**AWS Account Keys**

In order for Cloudbreak to be able to launch clusters on AWS on your behalf you need to set your AWS keys in the `Profile` file.
We suggest to use the keys of a valid **IAM User** here.

```
export AWS_ACCESS_KEY_ID=AKIA**************W7SA
export AWS_SECRET_ACCESS_KEY=RWCT4Cs8******************/*skiOkWD
```
## Start Cloudbreak Deployer

To start the Cloudbreak application use the following command.
This will start all the Docker containers and initialize the application.

```
cbd start
```

>At the very first time it will take for a while, because of need to download all the necessary docker images.

The `cbd start` command includes the `cbd generate` command which applies the following steps: 

- creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
- creates the **uaa.yml** file that holds the configuration of the identity server used to authenticate users to Cloudbreak.

## Validate the started Cloudbreak Deployer

After the `cbd start` command finishes followings are worthy to check:

- Pre-installed Cloudbreak Deployer version and health.
```
   `cbd` doctor
```
>In case of `cbd update` is needed, please check the related documentation for [Cloudbreak Deployer Update](operations.md#cloudbreak-deployer-update)

- Started Cloudbreak Application logs.
```
   `cbd` logs cloudbreak
```
>Cloudbreak should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`

# Provisioning Prerequisites

## IAM role setup

Cloudbreak works by connecting your AWS account through so called *Credentials*, and then uses these credentials to create resources on your behalf.

>**IMPORTANT** Cloudbreak deployment uses two different AWS accounts for two different purposes:

- The account belonging to the *Cloudbreak webapp* itself, acts as a *third party*, that creates resources on the 
account of the *end user*. This account is configured at server-deployment time.
- The account belonging to the *end user* who uses the UI or the Shell to create clusters. This account is configured when setting up credentials.

These accounts are usually *the same* when the end user is the same who deployed the Cloudbreak server, but it allows Cloudbreak to act as a SaaS project as well if needed.

Credentials use [IAM Roles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) to give access to the third party to act on behalf of the end user without giving full access to your resources.
This IAM Role will be *assumed* later by an IAM user.

**AWS IAM Policy that grants permission to assume a role**

**You cannot assume a role with root account**, so you need to **create an IAM user** with an attached [*Inline* 
policy](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html) and **then set the Access key and Secret Access key** in the 
`Profile` file (check [this description](aws.md#aws-specific-configuration) out).

The `sts-assume-role` IAM user [policy](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_control-access_enable-create.html) must be configured to have 
permission to assume roles on all resources. Here it is the policy to configure the `sts:AssumeRole` for all 
`Resource`:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1400068149000",
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```

To connect your (*end user*) AWS account with a credential in Cloudbreak you'll have to create an IAM role on your AWS account that is configured to allow the third-party account to access and create resources on your behalf.
The easiest way to do this is with `cbd` commands (but it can also be done manually from the [AWS Console](https://console.aws.amazon.com)):

```
cbd aws generate-role  - Generates an AWS IAM role for Cloudbreak provisioning on AWS
cbd aws show-role      - Show assumers and policies for an AWS role
cbd aws delete-role    - Deletes an AWS IAM role, removes all inline policies
```

The `generate-role` command creates a role that is assumable by the Cloudbreak Deployer AWS account and has a broad policy setup.
This command creates a role with the name `cbreak-deployer` by default. If you'd like to create role with a different
 name or multiple roles, you need to add this line to your `Profile`:

```
export AWS_ROLE_NAME=my-cloudbreak-role
```
You can check the generated role on your AWS console, under IAM roles:
![](/images/aws-iam-role.png)
<sub>*Full size [here](/images/aws-iam-role.png).*</sub>

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

> **IMPORTANT** Make sure that you have sufficient qouta (CPU, network, etc) for the requested cluster size.

# Provisioning via Browser

You can log into the Cloudbreak application at http://`PUBLIC_IP`:3000.

The main goal of the Cloudbreak UI is to easily create clusters on your own cloud provider account.
This description details the AWS setup - if you'd like to use a different cloud provider check out its manual.

This document explains the four steps that need to be followed to create Cloudbreak clusters from the UI:

- connect your AWS account with Cloudbreak
- create some template resources on the UI that describe the infrastructure of your clusters
- create a blueprint that describes the HDP services in your clusters and add some recipes for customization
- launch the cluster itself based on these resources

## Setting up AWS credentials

Cloudbreak works by connecting your AWS account through so called *Credentials*, and then uses these credentials to 
create resources on your behalf. The credentials can be configured on the **manage credentials** panel on the 
Cloudbreak Dashboard.

To create a new AWS credential follow these steps:

  1. Select the credential type. For instance, select the `Role Based`
  2. Fill out the new credential `name`
    - Only alphanumeric and lowercase characters (min 5, max 100 characters) can be applied
  3. Copy your AWS IAM role's Amazon Resource Name (ARN) to the `IAM Role ARN` field
  4. Copy your SSH public key to the `SSH public key` field
    - The SSH public key must be in OpenSSH format and it's private keypair can be used later to [SSH onto every 
    instance](operations.md#ssh-to-the-hosts) of every cluster you'll create with this credential.
    - The **SSH username** for the EC2 instances is **ec2-user**.

>Any other parameter is optional here.

>`Public in account` means that all the users belonging to your account will be able to use this credential to create 
clusters, but cannot delete it.

![](/images/aws-credential.png)
<sub>*Full size [here](/images/aws-credential.png).*</sub>

## Infrastructure templates

After your AWS account is linked to Cloudbreak you can start creating templates that describe your clusters' infrastructure:

- security groups
- networks
- templates

When you create a template, Cloudbreak *doesn't make any requests* to AWS.
Resources are only created on AWS after the `create cluster` button is pushed.
These templates are saved to Cloudbreak's database and can be reused with multiple clusters to describe the infrastructure.

**Templates**

Templates describe the **instances of your cluster** - the instance type and the attached volumes. A typical setup is
 to combine multiple templates in a cluster for the different types of nodes. For example you may want to attach multiple
 large disks to the datanodes or have memory optimized instances for Spark nodes.

The instance templates can be configured on the **manage templates** panel on the Cloudbreak Dashboard.

There are some optional configurations here as well:

- `Spot price (USD)` If specified Cloudbreak will request spot price instances (which might take a while or never be 
fulfilled by Amazon). **This option is *not supported* by the default RedHat images**.
- `EBS encryption` is supported for all volume types. If this option is checked then all the attached disks [will be encrypted](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html) by Amazon using the AWS KMS master keys.
- If `Public in account` is checked all the users belonging to your account will be able to use this resource to create clusters, but cannot delete it.

**Networks**

Your clusters can be created in their own **Virtual Private Cloud (VPC)** or in one of your already existing VPCs.
If you choose an existing VPC it is possible to create a new subnet within the VPC or use an already existing one.
The subnet's IP range must be defined in the `Subnet (CIDR)` field using the general CIDR notation.

*Default AWS Network*

If you don't want to create or use your custom VPC, you can use the `default-aws-network` for all your 
Cloudbreak clusters. It will create a new VPC with a `10.0.0.0/16` subnet every time a cluster is created.

*Custom AWS Network*

If you'd like to deploy a cluster to a custom VPC you'll have to **create a new network** template on the **manage 
networks** panel. You can configure the `Subnet Identifier` and the `Internet Gateway Identifier` (IGW) of your VPC.

>**IMPORTANT** The subnet CIDR cannot overlap each other in a VPC. So you have to create different network 
templates for every each clusters.

To create a new subnet within the VPC, provide the ID of the subnet which is in the existing VPC and your cluster 
will be launched into that subnet. **For example** you can create 3 different clusters with 3 different network 
templates for multiple subnets `10.0.0.0/24`, `10.0.1.0/24`, `10.0.2.0/24` with the same VPC and IGW identifiers.

>**IMPORTANT** Please make sure the define subnet here doesn't overlap with any of your already deployed subnet in 
the VPC, because of the validation only happens after the cluster creation starts.

>In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

If `Public in account` is checked all the users belonging to your account will be able to use this network template to create clusters, but cannot delete it.

>**NOTE** The VPCs, IGWs and subnet are created on AWS only after the the cluster provisioning starts with the selected 
network template.

![](/images/aws-network.png)
<sub>*Full size [here](/images/aws-network.png).*</sub>

**Security groups**

Security group templates are very similar to the [security groups on the AWS Console](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html).
**They describe the allowed inbound traffic to the instances in the cluster.**
Currently only one security group template can be selected for a Cloudbreak cluster and all the instances have a public IP address so all the instances in the cluster will belong to the same security group.
This may change in a later release.

You can define your own security group by adding all the ports, protocols and CIDR range you'd like to use.  The rules defined here doesn't need to contain the internal rules, those are automatically added by Cloudbreak to the security group on AWS.

>**IMPORTANT** 443 needs to be there in every security group otherwise Cloudbreak won't be able to communicate with the 
provisioned cluster.

*Default Security Group*

You can also use the two pre-defined security groups in Cloudbreak.

`only-ssh-and-ssl:` all ports are locked down except for SSH and gateway HTTPS (you can't access Hadoop services outside of the VPC):

* SSH (22)
* HTTPS (443)

`all-services-port:` all Hadoop services and SSH, gateway and HTTPS are accessible by default:

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

If `Public in account` is checked all the users belonging to your account will be able to use this security group template to create clusters, but cannot delete it.

>**NOTE** The security groups are created on AWS only after the cluster provisioning starts with the selected security group template.

![](/images/ui-secgroup.png)
<sub>*Full size [here](/images/ui-secgroup.png).*</sub>

## Defining cluster services

**Blueprints**

Blueprints are your declarative definition of a Hadoop cluster. These are the same blueprints that are [used by Ambari](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints).

You can use the 3 default blueprints pre-defined in Cloudbreak or you can create your own.
Blueprints can be added from an URL (an example [blueprint](https://github.com/sequenceiq/ambari-rest-client/raw/1.6.0/src/main/resources/blueprints/multi-node-hdfs-yarn)) or the whole JSON can be copied to the `Manual copy` field.

The hostgroups added in the JSON will be mapped to a set of instances when starting the cluster and the services and components defined in the hostgroup will be installed on the corresponding nodes.
It is not necessary to define all the configuration fields in the blueprints - if a configuration is missing, Ambari will fill that with a default value.
The configurations defined in the blueprint can also be modified later from the Ambari UI.

If `Public in account` is checked all the users belonging to your account will be able to use this blueprint to create clusters, but cannot delete or modify it.

![](/images/ui-blueprints.png)

A blueprint can be exported from a running Ambari cluster that can be reused in Cloudbreak with slight modifications.
There is no automatic way to modify an exported blueprint and make it instantly usable in Cloudbreak, the modifications have to be done manually.
When the blueprint is exported some configurations will have hardcoded for example domain names, or memory configurations that won't be applicable to the Cloudbreak cluster.

**Cluster customization**

Sometimes it can be useful to define some custom scripts that run during cluster creation and add some additional functionality.
For example it can be a service you'd like to install but it's not supported by Ambari or some script that automatically downloads some data to the necessary nodes.
The most notable example is Ranger setup: it has a prerequisite of a running database when Ranger Admin is installing.
A PostgreSQL database can be easily started and configured with a recipe before the blueprint installation starts.

To learn more about these so called *Recipes*, and to check out the Ranger database recipe, take a look at the [Cluster customization](recipes.md) part of the documentation.


## Cluster deployment

After all the templates are configured you can deploy a new HDP cluster. Start by selecting a previously created AWS credential in the header.
Click on `create cluster`, give it a `name`, select a `Region` where the cluster infrastructure will be provisioned and select one of the `Networks` and `Security Groups` created earlier.
After you've selected a `Blueprint` as well you should be able to configure the `Template resources` and the number of nodes for all of the hostgroups in the blueprint.

If `Public in account` is checked all the users belonging to your account will be able to see the newly created cluster on the UI, but cannot delete or modify it.

If `Enable security` is checked as well, Cloudbreak will install Key Distribution Center (KDC) and the cluster will be Kerberized. See more about it in the [Kerberos](kerberos.md) section of this documentation.

After the `create and start cluster` button is pushed Cloudbreak will start to create resources on your AWS account.
Cloudbreak uses *CloudFormation* to create the resources - you can check out the resources created by Cloudbreak on the AWS Console under the CloudFormation page.

>**IMPORTANT** Always use Cloudbreak to delete the cluster. If that fails for some reason always try to delete the 
CloudFormation stack first.
Instances are started in an Auto Scaling Group so they may be restarted if you terminate an instance manually!

**Advanced options**

There are some advanced features when deploying a new cluster, these are the following:

`Availability Zone`: You can restrict the instances to a specific availability zone. It may be useful if you're using reserved instances.

`Use dedicated instances:` You can use [dedicated instances](https://aws.amazon.com/ec2/purchasing-options/dedicated-instances/) on EC2

`Minimum cluster size:` the provisioning strategy in case of the cloud provider cannot allocate all the requested nodes

`Validate blueprint:` feature to validate the Ambari blueprint. By default is switched on.

`Config recommendation strategy:` Specifies the strategy for how configuration recommendations may be applied to a cluster’s configuration. Recommended configurations gathered by the response of the stack advisor. 

* `NEVER_APPLY:`               Configuration recommendations are ignored with this option.
* `ONLY_STACK_DEFAULTS_APPLY:` Applies only on the default configurations for all included services.
* `ALWAYS_APPLY:`              Applies on all configuration properties.

## Cluster termination

You can terminate running or stopped clusters with the `terminate` button in the cluster details.

Sometimes Cloudbreak cannot synchronize it's state with the cluster state at the cloud provider and the cluster can't be terminated. In this case with the `Forced termination` option in the termination dialog box you can terminate the cluster at the Cloudbreak side anyway. **In this case you may need to manually remove resources at the cloud provider.**

# Interactive mode

Start the shell with `cbd util cloudbreak-shell`. This will launch the Cloudbreak shell inside a Docker container and you are ready to start using it.

You have to copy files into the `cbd` working directory, which you would like to use from shell. For example if your `cbd` working directory is `~/prj/cbd` then copy your blueprint and public ssh key file into this directory. You can refer to these files with their names from the shell.

### Create a cloud credential

In order to start using Cloudbreak you will need to have an AWS cloud credential configured.

>**NOTE** that Cloudbreak **does not** store your cloud user details - we work around the concept of [IAM](http://aws
.amazon.com/iam/) - on Amazon (or other cloud providers) you will have to create an IAM role, a policy and associate that with your Cloudbreak account.

```
credential create --EC2 --description "description" --name my-aws-credential --roleArn <arn role> --sshKeyPath <path of your AWS public key>
```

Alternatively you can upload your public key from an url as well, by using the `—sshKeyUrl` switch, or use the ssh string with `—sshKeyString` switch. You can check whether the credential was created successfully by using the `credential list` command. You can switch between your cloud credentials - when you’d like to use one and act with that you will have to use:

```
credential select --name my-aws-credential
```

### Create a template

A template gives developers and systems administrators an easy way to create and manage a collection of cloud infrastructure related resources, maintaining and updating them in an orderly and predictable fashion. A template can be used repeatedly to create identical copies of the same stack (or to use as a foundation to start a new stack).

```
template create --EC2 --name awstemplate --description aws-template --instanceType M3Xlarge --volumeSize 100 --volumeCount 2
```
You can check whether the template was created successfully by using the `template list` or `template show` command.

You can delete your cloud template - when you’d like to delete one you will have to use:
```
template delete --name awstemplate
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
network create --AWS --name awsnetwork --description aws-network --subnet 10.0.0.0/16
```

Other available options:

`--vpcID` your existing vpc on amazon

`--internetGatewayID` your amazon internet gateway of the given VPC

`--publicInAccount` flags if the network is public in the account

There is a default network with name `default-aws-network`. If we use this for cluster creation, Cloudbreak will create a new VPC with 10.0.0.0/16 subnet.

You can check whether the network was created successfully by using the `network list` command. Check the network and select it if you are happy with it:

```
network show --name awsnetwork

network select --name awsnetwork
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

`only-ssh-and-ssl:` all ports are locked down except for SSH and gateway HTTPS (you can't access Hadoop services outside of the VPC)

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

### Configure instance groups

You have to configure the instancegroups before the provisioning. An instancegroup is defining a group of your nodes with a specified template. Usually we create instancegroups for the hostgroups defined in the blueprints.

```
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName minviable-aws
```

Other available option:

`--templateId` Id of the template

### Create a Hadoop cluster
You are almost done - two more command and this will create your Hadoop cluster on your favorite cloud provider. Same as the API, or UI this will use your `credential`, `instancegroups`, `network`, `securitygroup`, and by using CloudFormation will launch a cloud stack
```
stack create --name my-first-stack --region US_EAST_1
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
>**Important!** The related cluster should be stopped before you can stop the stack.


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

With Cloudbreak shell you can execute script files as well. A script file contains cloudbreak shell commands and can be executed with the `script` cloudbreak shell command

```
script <your script file>
```

or with the `cbd util cloudbreak-shell-quiet` `cbd` command:

```
cbd util cloudbreak-shell-quiet < example.sh
```

## Example

The following example creates a hadoop cluster with `hdp-small-default` blueprint on M3Xlarge instances with 2X100G attached disks on `default-aws-network` network using `all-services-port` security group. You should copy your ssh public key file into your `cbd` working directory with name `id_rsa.pub` and change the `<arn role>` part with your arn role.

```
credential create --EC2 --description description --name my-aws-credential --roleArn <arn role> --sshKeyPath id_rsa.pub
credential select --name my-aws-credential
template create --EC2 --name awstemplate --description aws-template --instanceType M3Xlarge --volumeSize 100 --volumeCount 2
blueprint select --name hdp-small-default
instancegroup configure --instanceGroup cbgateway --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_master_1 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_master_2 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_master_3 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_client_1  --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName awstemplate
network select --name default-aws-network
securitygroup select --name all-services-port
stack create --name my-first-stack --region US_EAST_1
cluster create --description "My first cluster"
```

Congrats! Your cluster should now be up and running. To learn more about it we have some [interesting insights](operations.md) about Cloudbreak clusters.

