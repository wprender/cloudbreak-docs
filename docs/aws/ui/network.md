**Networks**

Your clusters can be created in their own **Virtual Private Cloud (VPC)** or in one of your already existing VPCs.
If you choose an existing VPC it is possible to create a new subnet within the VPC or use an already existing one.
The subnet's IP range must be defined in the `Subnet (CIDR)` field using the general CIDR notation.

*Default AWS Network*

If you don't want to create or use your custom VPC, you can use the `default-aws-network` for all your 
Cloudbreak clusters. It will create a new VPC with a `10.0.0.0/16` subnet every time a cluster is created.

*Custom AWS Network*

If you'd like to deploy a cluster to a custom VPC you'll have to **create a new network** template on the **manage 
networks** panel.

You have the following options:

* **Create a new VPC and a new subnet**: Every time a cluster is created with this kind of network setup a new VPC and a new subnet with the specified IP range will be created for the instances on AWS.
* **Create a new subnet in an existing VPC**:  Use this kind of network setup if you already have a VPC on AWS where you'd like to put the Cloudbreak created cluster but you'd like to have a separate subnet for it.
* **Use an existing subnet in an existing VPC**:  Use this kind of network setup if you have an existing VPC with one or more subnets on AWS and you'd like to start the instances of a cluster in one of those subnets.

 You can configure the `Subnet Identifier` and the `Internet Gateway Identifier` (IGW) of your VPC.

>**IMPORTANT** The subnet CIDR cannot overlap each other in a VPC. So you have to create different network 
templates for every each clusters.

To create a new subnet within the VPC, provide the ID of the subnet which is in the existing VPC and your cluster 
will be launched into that subnet. **For example** you can create 3 different clusters with 3 different network 
templates for multiple subnets `10.0.0.0/24`, `10.0.1.0/24`, `10.0.2.0/24` with the same VPC and IGW identifiers.

>**IMPORTANT** Please make sure the define subnet here doesn't overlap with any of your already deployed subnet in 
the VPC, because of the validation only happens after the cluster creation starts.

>In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

If `Public in account` is checked all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

>**NOTE** The VPCs, IGWs and subnet are created on AWS only after the the cluster provisioning starts with the selected 
network template.

![](/aws/images/aws-network_v4.png)
<sub>*Full size [here](/aws/images/aws-network_v4.png).*</sub>
