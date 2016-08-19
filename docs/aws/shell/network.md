#### Networks

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
