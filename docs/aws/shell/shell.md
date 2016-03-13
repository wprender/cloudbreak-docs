## Setting up AWS credential

Cloudbreak works by connecting your AWS account through so called Credentials, and then uses these credentials to 
create resources on your behalf. Credentials can be configured with the following command for example:

```
credential create --AWS --name my-aws-credential --description "sample description" --roleArn 
arn:aws:iam::***********:role/userrole --sshKeyString "ssh-rsa AAAAB****etc"
```

>**NOTE** that Cloudbreak **does not set your cloud user details** - we work around the concept of [IAM](http://aws.amazon.com/iam/) - **on Amazon (or other cloud providers)**. You should have already a valid IAM role. You can 
find further details [here](aws.md#provisioning-prerequisites).

Alternatives to provide `SSH Key`:

- you can upload your public key from an url: `—sshKeyUrl` 
- or you can add the path of your public key: `—sshKeyPath`

You can check whether the credential was created successfully

```
credential list
```

You can switch between your existing credentials

```
credential select --name my-aws-credential
```

## Infrastructure templates

After your AWS account is linked to Cloudbreak you can start creating resource templates that describe your clusters' infrastructure:

- security groups
- networks
- templates

When you create one of the above resource, **Cloudbreak does not make any requests to AWS. Resources are only created
 on AWS after the `cluster create` has applied.** These templates are saved to Cloudbreak's database and can be 
 reused with multiple clusters to describe the infrastructure.

**Templates**

Templates describe the **instances of your cluster** - the instance type and the attached volumes. A typical setup is
 to combine multiple templates in a cluster for the different types of nodes. For example you may want to attach multiple
 large disks to the datanodes or have memory optimized instances for Spark nodes.

A template can be used repeatedly to create identical copies of the same stack (or to use as a foundation to start a 
new stack). Templates can be configured with the following command for example:
```
template create --AWS --name my-aws-template --description "sample description" --instanceType m4.large --volumeSize 
100 --volumeCount 2
```

Other available option here is `--publicInAccount`. If it is true, all the users belonging to your account will be able
 to use this template to create clusters, but cannot delete it.

You can check whether the template was created successfully
```
template list
```

**Networks**

Your clusters can be created in their own **Virtual Private Cloud (VPC)** or in one of your already existing VPCs. If 
you choose an existing VPC it is possible to create a new subnet within the VPC or use an already existing one. The 
subnet's IP range must be defined in the `Subnet (CIDR)` field using the general CIDR notation.

*Default AWS Network*

If you don't want to create or use your custom VPC, you can use the `default-aws-network` for all your Cloudbreak 
clusters. It will create a new VPC with a `10.0.0.0/16` subnet every time a cluster is created.

*Custom AWS Network*

If you'd like to deploy a cluster to a custom VPC you'll have to **create a new network** template, to create a new 
subnet within the VPC, provide the ID of the subnet which is in the existing VPC.

A network also can be used repeatedly to create identical copies of the same stack (or to use as a foundation to 
start a new stack).

>**IMPORTANT** The subnet CIDR cannot overlap each other in a VPC. So you have to create different network templates 
for every each clusters.
>For example you can create 3 different clusters with 3 different network templates for multiple subnets 10.0.0.0/24,
 10.0.1.0/24, 10.0.2.0/24 with the same VPC and IGW identifiers.

```
network create --AWS --name my-aws-network --subnet 10.0.0.0/16
```

Other available options:

`--vpcID` your existing vpc on amazon

`--internetGatewayID` your amazon internet gateway of the given VPC

`--publicInAccount` If it is true, all the users belonging to your account will be able to use this network to create 
clusters, but cannot delete it.

You can check whether the network was created successfully
```
network list
```

**Security groups**

Security group templates are very similar to the [security groups on the AWS Console](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html). **They describe the allowed 
inbound traffic to the instances in the cluster.** Currently only one security group template can be selected for a 
Cloudbreak cluster and all the instances have a public IP address so all the instances in the cluster will belong to 
the same security group. This may change in a later release.

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

*Custom Security Group*

You can define your own security group by adding all the ports, protocols and CIDR range you'd like to use. The rules
 defined here doesn't need to contain the internal rules, those are automatically added by Cloudbreak to the security group on AWS.

>**IMPORTANT** 443 needs to be there in every security group otherwise Cloudbreak won't be able to communicate with the 
provisioned cluster.

```
securitygroup create --name my-security-group --description "sample description" --rules 0.0.0.0/0:tcp:443,8080,9090;10.0.33.0/24:tcp:1234,1235
```

If `--publicInAccount` is true, all the users belonging to your account will be able
 to use this template to create clusters, but cannot delete it.

>**NOTE** The security groups are created on AWS only after the cluster provisioning starts with the selected security group template.

You can check whether the security group was created successfully
```
securitygroup list
``` 

## Defining cluster services

**Blueprints**

Blueprints are your declarative definition of a Hadoop cluster. These are the same blueprints that are [used by Ambari](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints).

You can use the 3 default blueprints pre-defined in Cloudbreak or you can create your own ones.
Blueprints can be added from file or URL (an [example blueprint](https://raw.githubusercontent.com/sequenceiq/cloudbreak/master/integration-test/src/main/resources/blueprint/multi-node-hdfs-yarn.bp)).

The host groups in the JSON will be mapped to a set of instances when starting the cluster. Besides this the services and
 components will also be installed on the corresponding nodes. Blueprints can be modified later from the Ambari UI.
 
>**NOTE** Not necessary to define all the configuration in the blueprint. If a configuration is missing, Ambari will fill that with a default value.

```
blueprint add --name my-blueprint --description "sample description" --file <the path of the blueprint>
```
Other available options:

`--url` the url of the blueprint

`--publicInAccount` If it is true, all the users belonging to your account will be able to use this blueprint to create 
clusters, but cannot delete it.

You can check whether the blueprint was created successfully
```
blueprint list
```

**A blueprint can be exported from a running Ambari cluster that can be reused in Cloudbreak with slight 
modifications.**
There is no automatic way to modify an exported blueprint and make it instantly usable in Cloudbreak, the 
modifications have to be done manually.
When the blueprint is exported some configurations are hardcoded for example domain names, memory configurations..etc. that won't be applicable to the Cloudbreak cluster.

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

After all the cluster resources are configured you can deploy a new HDP cluster. The following sub-sections show 
you a **basic flow for cluster creation with Cloudbreak Shell**.

**Select credential**

Select one of your previously created AWS credential:
```
credential select --name my-aws-credential
```

**Select blueprint**

Select one of your previously created blueprint which fits your needs:
```
blueprint select --name multi-node-hdfs-yarn
```

**Configure instance groups**

You must configure instance groups before provisioning. An instance group define a group of nodes with a specified 
template. Usually we create instance groups for host groups in the blueprint.

```
instancegroup configure --instanceGroup cbgateway --nodecount 1 --templateName minviable-aws
instancegroup configure --instanceGroup master --nodecount 1 --templateName minviable-aws
instancegroup configure --instanceGroup slave_1 --nodecount 1 --templateName minviable-aws
```
Other available option:

`--templateId` Id of the template

**Select network**

Select one of your previously created network which fits your needs or a default one:
```
network select --name default-aws-network
```

**Select security group**

Select one of your previously created security which fits your needs or a default one:
```
securitygroup select --name all-services-port
```
**Create stack / Create cloud infrastructure**

Stack means the running cloud infrastructure that is created based on the instance groups configured earlier 
(`credential`, `instancegroups`, `network`, `securitygroup`). Same as in case of the API or UI the new cluster will 
use your templates and by using CloudFormation will launch your cloud stack. Use the following command to create a 
stack to be used with your Hadoop cluster:
```
stack create --name myawsstack --region us-east-1
```
The infrastructure is created asynchronously, the state of the stack can be checked with the stack `show command`. If 
it reports AVAILABLE, it means that the virtual machines and the corresponding infrastructure is running at the cloud provider.

Other available option is `--wait` - in this case the create command will return only after the process has finished. 

**Create a Hadoop cluster / Cloud provisioning**

**You are almost done! One more command and your Hadoop cluster is starting!** Cloud provisioning is done once the 
cluster is up and running. The new cluster will use your selected blueprint and install your custom Hadoop cluster 
with the selected components and services.

```
cluster create --description "my first cluster"
```
You can use the `--wait` parameter here as well. 

**You are done!** You have several opportunities to check the progress during the infrastructure creation then 
provisioning:

- Cloudbreak uses *CloudFormation* to create the resources - you can check out the resources created by Cloudbreak on
 the AWS Console CloudFormation page.

For example:
![](/aws/images/aws-cloudformation_v2.png)
<sub>*Full size [here](/aws/images/aws-cloudformation_v2.png).*</sub>

- If stack then cluster creation have successfully done, you can check the Ambari Web UI. However you need to know the 
Ambari IP (for example: `http://52.8.110.95:8080`): 
    - You can get the IP from the CLI as a result (`ambariServerIp 52.8.110.95`) of the following command:
```
         cluster show
```

For example:
![](/images/ambari-dashboard.png)
<sub>*Full size [here](/images/ambari-dashboard.png).*</sub>

- Besides these you can check the entire progress and the Ambari IP as well on the Cloudbreak Web UI itself. Open the 
new cluster's `details` and its `Event History` here.

For example:
![](/images/ui-eventhistory_v3.png)
<sub>*Full size [here](/images/ui-eventhistory_v3.png).*</sub>

**Stop cluster**

You have the ability to **stop your existing stack then its cluster** if you want to suspend the work on it.

Select a stack for example with its name:
```
stack select --name my-stack
```
Other available option to define a stack is its `--id`.

Every time you should stop the `cluster` first then the `stack`. So apply following commands to stop the previously 
selected stack:
```
cluster stop
stack stop
```

**Restart cluster**

**Select your stack that you would like to restart** after this you can apply:
```
stack start
```
After the stack has successfully restarted, you can **restart the related cluster as well**:
```
cluster start
```

**Upscale cluster**

If you need more instances to your infrastructure, you can **upscale your selected stack**:
```
stack node --ADD --instanceGroup host_group_slave_1 --adjustment 6
```
Other available option is `--withClusterUpScale` - this indicates also a cluster upscale after the stack upscale. You
 can upscale the related cluster separately if you want to do this:
```
cluster node --ADD --hostgroup host_group_slave_1 --adjustment 6
```
**Downscale cluster**

You also can reduce the number of instances in your infrastructure. **After you selected your stack**:
```
cluster node --REMOVE  --hostgroup host_group_slave_1 --adjustment -2
```
Other available option is `--withStackDownScale` - this indicates also a stack downscale after the cluster downscale.
 You can downscale the related stack separately if you want to do this:
```
stack node --REMOVE  --instanceGroup host_group_slave_1 --adjustment -2
```

## Cluster termination

You can terminate running or stopped clusters with

```
stack terminate --name myawsstack
```

>**IMPORTANT** Always use Cloudbreak to terminate the cluster. If that fails for some reason, try to delete the 
CloudFormation stack first. Instances are started in an Auto Scaling Group so they may be restarted if you terminate an instance manually!

Sometimes Cloudbreak cannot synchronize it's state with the cluster state at the cloud provider and the cluster can't
 be terminated. In this case the `Forced termination` option on the Cloudbreak Web UI can help to terminate the cluster
  at the Cloudbreak side. **If it has happened:**

1. You should check the related resources at the AWS CloudFormation
2. If it is needed you need to manually remove resources from there

## Silent mode

With Cloudbreak Shell you can execute script files as well. A script file contains shell commands and can 
be executed with the `script` cloudbreak shell command

```
script <your script file>
```

or with the `cbd util cloudbreak-shell-quiet` command

```
cbd util cloudbreak-shell-quiet < example.sh
```

>**IMPORTANT** You have to copy all your files into the `cbd` working directory, what you would like to use in shell.
 For example if your `cbd` working directory is ~/cloudbreak-deployment then copy your script file to here.

### Example

The following example creates a Hadoop cluster with `hdp-small-default` blueprint on M4Xlarge instances with 2X100G 
attached disks on `default-aws-network` network using `all-services-port` security group. You should copy your ssh 
public key file into your `cbd` working directory with name `id_rsa.pub` and paste your AWS credentials in the parts with `<...>` highlight.


```
credential create --AWS --description description --name my-aws-credential --roleArn <arn role> --sshKeyPath id_rsa.pub
credential select --name my-aws-credential
template create --AWS --name awstemplate --description aws-template --instanceType m4.xlarge --volumeSize 100 
--volumeCount 2
blueprint select --name hdp-small-default
instancegroup configure --instanceGroup cbgateway --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_master_1 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_master_2 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_master_3 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_client_1  --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName awstemplate
network select --name default-aws-network
securitygroup select --name all-services-port
stack create --name my-first-stack --region us-east-1
cluster create --description "My first cluster"
```
