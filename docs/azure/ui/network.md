**Networks**

Your clusters can be created in their own **networks** or in one of your already existing one. If you choose an 
existing network, it is possible to create a new subnet within the network. The subnet's IP range must be defined in 
the `Subnet (CIDR)` field using the general CIDR notation.

*Default AZURE Network*

If you don't want to create or use your custom network, you can use the `default-azure-network` for all your 
Cloudbreak clusters. It will create a new network with a `10.0.0.0/16` subnet every time a cluster is created.

*Custom AZURE Network*

If you'd like to deploy a cluster to a custom network you'll have to **create a new network** template on the **manage 
networks** panel. You can define the `Subnet Identifier` and the `Virtual Network Identifier` of your network.

`Virtual Network Identifier` is an optional value. This must be an ID of an existing AZURE virtual network. If the 
identifier is provided, the subnet CIDR will be ignored and the existing network's CIDR range will be used.

>**IMPORTANT** Please make sure the defined subnet here doesn't overlap with any of your already deployed subnet in the
 network, because of the validation only happens after the cluster creation starts.
   
>In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

If `Public in account` is checked all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

>**NOTE** The new networks are created on AZURE only after the the cluster provisioning starts with the selected 
network template.

![](/azure/images/azure-network.png)
<sub>*Full size [here](/azure/images/azure-network.png).*</sub>