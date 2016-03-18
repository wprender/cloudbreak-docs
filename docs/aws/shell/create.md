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

Other available option is:

`--wait` - in this case the create command will return only after the process has finished. 

**Create a Hadoop cluster / Cloud provisioning**

**You are almost done! One more command and your Hadoop cluster is starting!** Cloud provisioning is done once the 
cluster is up and running. The new cluster will use your selected blueprint and install your custom Hadoop cluster 
with the selected components and services.

```
cluster create --description "my first cluster"
```
Other available option is `--wait` - in this case the create command will return only after the process has finished. 

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








