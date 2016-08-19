#### Networks

Your clusters can be created in their own **networks** or in one of your already existing one. If you choose an 
existing network, it is possible to create a new subnet within the network. The subnet's IP range must be defined in 
the `Subnet (CIDR)` field using the general CIDR notation. You can read more about [GCP Networks](https://cloud.google.com/compute/docs/networking#networks) and [Subnet 
networks](https://cloud.google.com/compute/docs/networking#subnet_network).

*Default GCP Network*

If you don't want to create or use your custom network, you can use the `default-gcp-network` for all your 
Cloudbreak clusters. It will create a new network with a `10.0.0.0/16` subnet every time a cluster is created.

*Custom GCP Network*

If you'd like to deploy a cluster to a custom network you'll have to **create a new network** template on the **manage 
networks** panel.

You have the following options:

* **Create a new virtual network and a new subnet**: Every time a cluster is created with this kind of network setup a new virtual network and a new subnet with the specified IP range will be created for the instances on Google Cloud.
* **Create a new subnet in an existing virtual network**: Use this kind of network setup if you already have a virtual network on Google Cloud where you'd like to put the Cloudbreak created cluster but you'd like to have a separate subnet for it.
* **Use an existing subnet in an existing virtual network**: Use this kind of network setup if you have an existing virtual network with one or more subnets on Google Cloud and you'd like to start the instances of a cluster in one of those subnets.
* **Use a legacy network without subnets**: Use this kind of network setup if you have a legacy virtual network on Google Cloud that doesn't have subnet support and you'd like to start instances in that virtual network directly.

>**IMPORTANT:** Please make sure the defined subnet here doesn't overlap with any of your already deployed subnet in the
 network, because of the validation only happens after the cluster creation starts.

>In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

If `Public in account` is checked all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

>**NOTE:** The new networks are created on GCP only after the the cluster provisioning starts with the selected 
network template.

![](/gcp/images/gcp-network_v2.png)
<sub>*Full size [here](/gcp/images/gcp-network_v2.png).*</sub>
