## Setting up GCP credential

Cloudbreak works by connecting your GCP account through so called Credentials, and then uses these credentials to 
create resources on your behalf. Credentials can be configured with the following command for example:
```
credential create --GCP --description "sample description" --name my-gcp-credential --projectId <your gcp projectid> 
--serviceAccountId <your GCP service account mail address> --serviceAccountPrivateKeyPath /files/mykey.p12 
--sshKeyString "ssh-rsa AAAAB3***etc."
```
>**NOTE** that Cloudbreak **does not set your cloud user details** - we work around the concept of GCP Service 
Account Credentials. You should have already a valid GCP service account. You can find further details [here](gcp.md#provisioning-prerequisites).

Alternatives to provide `SSH Key`:

- you can upload your public key from an url: `—sshKeyUrl` 
- or you can add the path of your public key: `—sshKeyPath`

You can check whether the credential was created successfully
```
credential list
```
You can switch between your existing credentials
```
credential select --name my-gcp-credential
```
## Infrastructure templates

After your GCP account is linked to Cloudbreak you can start creating resource templates that describe your clusters' 
infrastructure:

- security groups
- networks
- templates

When you create one of the above resource, **Cloudbreak does not make any requests to GCP. Resources are only created
 on GCP after the `cluster create` has applied.** These templates are saved to Cloudbreak's database and can be 
 reused with multiple clusters to describe the infrastructure.

**Templates**

Templates describe the **instances of your cluster** - the instance type and the attached volumes. A typical setup is
 to combine multiple templates in a cluster for the different types of nodes. For example you may want to attach multiple
 large disks to the datanodes or have memory optimized instances for Spark nodes.

A template can be used repeatedly to create identical copies of the same stack (or to use as a foundation to start a 
new stack). Templates can be configured with the following command for example:
```
template create --GCP --name my-gcp-template --instanceType n1-standard-2 --volumeCount 2 --volumeSize 100
```
Other available options here:

`--volumeType` The default is `pd-standard` (HDD), other allowed value is `pd-ssd` 
(SSD).

`--publicInAccount` is true, all the users belonging to your account will be able to use this template 
to create clusters, but cannot delete it.

You can check whether the template was created successfully
```
template list
```
**Networks**

Your clusters can be created in their own **networks** or in one of your already existing one. If you choose an 
existing network, it is possible to create a new subnet within the network. The subnet's IP range must be defined in 
the `Subnet (CIDR)` field using the general CIDR notation. You can read more about [GCP Networks](https://cloud.google.com/compute/docs/networking#networks) and [Subnet networks](https://cloud.google.com/compute/docs/networking#subnet_network).

*Default GCP Network*

If you don't want to create or use your custom network, you can use the `default-gcp-network` for all your 
Cloudbreak clusters. It will create a new network with a `10.0.0.0/16` subnet every time a cluster is created.

*Custom GCP Network*

If you'd like to deploy a cluster to a custom network you'll have to apply the following command:
```
network create --GCP --name my-gcp-network --description "sample description" --subnet 10.0.0.0/16
```
Other available options here:

`--networkId` The Virtual Network Identifier of your network. This is an optional 
value and must be an ID of an existing GCP virtual network. If the identifier is provided, the subnet CIDR will be 
ignored and the existing network's CIDR range will be used.

`--publicInAccount` is true, all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

>**IMPORTANT** Please make sure the defined subnet here doesn't overlap with any of your 
already deployed subnet in the network, because of the validation only happens after the cluster creation starts.
   
>In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

You can check whether the network was created successfully
```
network list
```
>**NOTE** The new networks are created on GCP only after the the cluster provisioning starts with the selected 
network template.

**Security groups**

Security group templates are very similar to the [firewalls on GCP](https://cloud.google.com/compute/docs/networks-and-firewalls#firewalls). **They describe the allowed 
inbound traffic to the instances in the cluster.** Currently only one security group template can be selected for a 
Cloudbreak cluster and all the instances have a public IP address so all the instances in the cluster will belong to 
the same security group. This may change in a later release.

*Default Security Group*

You can also use the two pre-defined security groups in Cloudbreak.

`only-ssh-and-ssl:` all ports are locked down except for SSH and gateway HTTPS (you can't access Hadoop services 
outside of the virtual network):

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
 defined here doesn't need to contain the internal rules, those are automatically added by Cloudbreak to the security
  group on GCP.

>**IMPORTANT** 443 needs to be there in every security group otherwise Cloudbreak won't be able to communicate with the 
provisioned cluster.

```
securitygroup create --name my-security-group --description "sample description" --rules 0.0.0.0/0:tcp:443,8080,9090;10.0.33.0/24:tcp:1234,1235
```

If `--publicInAccount` is true, all the users belonging to your account will be able to use this template 
to create clusters, but cannot delete it.

>**NOTE** The security groups are created on GCP only after the cluster provisioning starts with the selected security
 group template.

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
Other available options here:

`--url` the url of the blueprint

`--publicInAccount` is true, all the users belonging to your account will be able to use this blueprint 
to create clusters, but cannot delete it.

You can check whether the blueprint was created successfully
```
blueprint list
```

**A blueprint can be exported from a running Ambari cluster that can be reused in Cloudbreak with slight 
modifications.**
There is no automatic way to modify an exported blueprint and make it instantly usable in Cloudbreak, the 
modifications have to be done manually.
When the blueprint is exported some configurations are hardcoded for example domain names, memory configurations...etc. that won't be applicable to the Cloudbreak cluster.

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

Select one of your previously created GCP credential:
```
credential select --name my-gcp-credential
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
instancegroup configure --instanceGroup cbgateway --nodecount 1 --templateName minviable-gcp
instancegroup configure --instanceGroup master --nodecount 1 --templateName minviable-gcp
instancegroup configure --instanceGroup slave_1 --nodecount 1 --templateName minviable-gcp
```
Other available option:

`--templateId` Id of the template

**Select network**

Select one of your previously created network which fits your needs or a default one:
```
network select --name default-gcp-network
```

**Select security group**

Select one of your previously created security which fits your needs or a default one:
```
securitygroup select --name all-services-port
```
**Create stack / Create cloud infrastructure**

Stack means the running cloud infrastructure that is created based on the instance groups configured earlier 
(`credential`, `instancegroups`, `network`, `securitygroup`). Same as in case of the API or UI the new cluster will 
use your templates and by using GCP will launch your cloud stack. Use the following command to create a 
stack to be used with your Hadoop cluster:
```
stack create --name mygcpstack --region us-central1
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

- Cloudbreak uses *Google Cloud Platform* to create the resources - you can check out the resources created by 
Cloudbreak on the Compute Engine page of the Google Compute Platform..

![](/gcp/images/gcp-computeengine_2.png)
<sub>*Full size [here](/gcp/images/gcp-computeengine_2.png).*</sub>

- If stack then cluster creation have successfully done, you can check the Ambari Web UI. However you need to know the 
Ambari IP (for example: `http://130.211.163.13:8080`): 
    - You can get the IP from the CLI as a result (`ambariServerIp 130.211.163.13`) of the following command:
```
         cluster show
```

![](/images/ambari-dashboard_3.png)
<sub>*Full size [here](/images/ambari-dashboard_3.png).*</sub>

- Besides these you can check the entire progress and the Ambari IP as well on the Cloudbreak Web UI itself. Open the 
new cluster's `details` and its `Event History` here.

![](/gcp/images/gcp-eventhistory_2.png)
<sub>*Full size [here](/gcp/images/gcp-eventhistory_2.png).*</sub>

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
stack terminate --name mygcpstack
```

>**IMPORTANT** Always use Cloudbreak to terminate the cluster. If that fails for some reason, try to delete the 
GCP resource group first. Instances are started in an Auto Scaling Group so they may be restarted if you terminate an 
instance manually!

Sometimes Cloudbreak cannot synchronize it's state with the cluster state at the cloud provider and the cluster can't
 be terminated. In this case the `Forced termination` option on the Cloudbreak Web UI can help to terminate the cluster
  at the Cloudbreak side. **If it has happened:**

1. You should check the related resources at the GCP
2. If it is needed you need to manually remove resources from there

## Silent mode

With Cloudbreak shell you can execute script files as well. A script file contains cloudbreak shell commands and can be executed with the `script` cloudbreak shell command

```
script <your script file>
```

or with the `cbd util cloudbreak-shell-quiet` `cbd` command:

```
cbd util cloudbreak-shell-quiet < example.sh
```
>**IMPORTANT** You have to copy all your files into the `cbd` working directory, what you would like to use in shell. For 
example if your `cbd` working directory is ~/cloudbreak-deployment then copy your script file to here.

### Example

The following example creates a hadoop cluster with `hdp-small-default` blueprint on M3Xlarge instances with 2X100G 
attached disks on `default-gcp-network` network using `all-services-port` security group. You should copy your ssh 
public key file (with name `id_rsa.pub`) and your GCP service account generated private key ( with name `gcp.p12`) into your `cbd` working 
directory and change the `<...>` parts with your GCP credential details.

```
credential create --GCP --description "my credential" --name my-gcp-credential --projectId <your gcp projectid> --serviceAccountId <your GCP service account mail address> --serviceAccountPrivateKeyPath gcp.p12 --sshKeyFile id_rsa.pub
credential select --name my-gcp-credential
template create --GCP --name gcptemplate --description gcp-template --instanceType n1-standard-4 --volumeSize 100 
--volumeCount 2
blueprint select --name hdp-small-default
instancegroup configure --instanceGroup cbgateway --nodecount 1 --templateName gcptemplate
instancegroup configure --instanceGroup host_group_master_1 --nodecount 1 --templateName gcptemplate
instancegroup configure --instanceGroup host_group_master_2 --nodecount 1 --templateName gcptemplate
instancegroup configure --instanceGroup host_group_master_3 --nodecount 1 --templateName gcptemplate
instancegroup configure --instanceGroup host_group_client_1  --nodecount 1 --templateName gcptemplate
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName gcptemplate
network select --name default-gcp-network
securitygroup select --name all-services-port
stack create --name my-first-stack --region us-central1
cluster create --description "My first cluster"
```
