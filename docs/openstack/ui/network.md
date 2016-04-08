**Networks**

Your clusters can be created in their own **networks** or in one of your already existing one. If you choose an 
existing network, it is possible to create a new subnet within the network. The subnet's IP range must be defined in 
the `Subnet (CIDR)` field using the general CIDR notation. Here you can read more about [OpenStack networking](http://docs.openstack.org/liberty/networking-guide/intro-networking.html).

*Custom OpenStack Network*

If you'd like to deploy a cluster to your OpenStack network you'll have to **create a new network** template on the 
**manage networks** panel on the Cloudbreak Dashboard.

>"Before launching an instance, you must create the necessary virtual network infrastructure...an instance uses a 
public provider virtual network that connects to the physical network infrastructure...This network includes a DHCP 
server that provides IP addresses to instances...The admin or other privileged user must create this network because 
it connects directly to the physical network infrastructure."

>Here you can read more about OpenStack [virtual network](http://docs.openstack.org/liberty/install-guide-rdo/launch-instance.html#create-virtual-networks) and [public provider network](http://docs.openstack.org/liberty/install-guide-rdo/launch-instance-networks-public.html).

You have the following options to create a new network:

* **Create a new network and a new subnet**: Every time a cluster is created with this kind of network setup a new network and a new subnet with the specified IP range will be created for the instances on OpenStack.
* **Create a new subnet in an existing network**: Use this kind of network setup if you already have a network on OpenStack where you'd like to put the Cloudbreak created cluster but you'd like to have a separate subnet for it.
* **Use an existing subnet in an existing network**: Use this kind of network setup if you have an existing network with one or more subnets on OpenStack and you'd like to start the instances of a cluster in one of those subnets.

Explanation of the parameters:

- `Name` the name of the new network
    - it must be between 5 and 100 characters long
    - Starts with a lowercase alphabetic character
    - Can contain lowercase alphanumeric and hyphens only
- `Subnet (CIDR)` Copy your OpenStack public network's subnet with CIDR block to the `Subnet (CIDR)` field
- `Public Network ID` Copy your OpenStack public network ID to the `Public Network ID` field
- `Virtual Network Identifier` This must be an ID of an existing OpenStack virtual network.
- `Router Identifier` Your virtual network router ID (must be provided in case of existing virtual network).
- `Subnet Identifier` Your subnet ID within your virtual network. If the identifier is provided, the `Subnet (CIDR)` will be ignored.

>**IMPORTANT** Please make sure the defined subnet here doesn't overlap with any of your already deployed subnet in the
 network, because of the validation only happens after the cluster creation starts.

>In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

If `Public in account` is checked all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

>**NOTE** The new networks are created on OpenStack only after the the cluster provisioning starts with the selected 
network template.

![](/images/os-networks_v2.png)
<sub>*Full size [here](/images/os-networks_v2.png).*</sub>
