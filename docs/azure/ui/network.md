**Networks**

Your clusters can be created in their own **networks** or in one of your already existing one. The subnet's IP range must be defined in 
the `Subnet (CIDR)` field using the general CIDR notation.

*Default AZURE Network*

If you don't want to create or use your custom network, you can use the `default-azure-network` for all your 
Cloudbreak clusters. It will create a new network with a `10.0.0.0/16` subnet every time a cluster is created.

*Custom AZURE Network*

If you'd like to deploy a cluster to a custom network you'll have to **create a new network** template on the **manage 
networks** panel. If you have an existing network on Azure you can define the `Subnet Identifier` and the `Virtual Network Identifier` and the `Resource Group Identifier` of your network.

The `Resource Group Identifier` identifies the resource group which contains your existing virtual network. The `Virtual Network Identifier` and the 
`Subnet Identifier` will tell Cloudbreak which network and subnet to use to launch the new instances.

>**IMPORTANT** In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but the existing subnet's CIDR range will be used. The security group behavior will be changed in this case as well
described in the security group section below.

If `Public in account` is checked all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

>**NOTE** The new networks are created on AZURE only after the the cluster provisioning starts with the selected 
network template.

![](/azure/images/azure-network_v2.png)
<sub>*Full size [here](/azure/images/azure-network_v2.png).*</sub>
