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
    - Length must be between 5 and 100 characters
    - Starts with a lowercase alphabetic character
    - Can contain lowercase alphanumeric and hyphens only
- `Subnet (CIDR)` With this field you define the IP address space usable by your VMs within the cluster. Cloudbreak supports the private address space defined in [RFC1918](https://tools.ietf.org/html/rfc1918). E.g. you can use 10.0.0.0/24
- `Floating Pool ID` [Floating IPs](http://docs.openstack.org/openstack-ops/content/floating_ips.html)  are not automatically allocated to instances by default, they needs to be attached to instances after creation. The Floating IPs are used to provide access to your VMs running on OpenStack. You can figure out the available network pools and their IDs by using the `nova floating-ip-pool-list` and `neutron net-external-list` or copy-pasting it from OpenStack Horizon UI. Such networks have the `External Network` field set to `Yes`. If you are unable to find the ID then just consult with your OpenStack network administrator. Please note that if you do not set this field then your cluster might not be accessible.
- `Virtual Network Identifier` This is the ID of an existing virtual network on OpenStack where you would like to launch the cluster. (Must be provided for **Create a new subnet in an existing network** and **Use an existing subnet in an existing network**)
- `Router Identifier` Specify the router ID that shall interconnect your existing Network with the Subnet which will be created by CLoudbreak. (Must be provided for **Create a new subnet in an existing network**).
- `Subnet Identifier` This is the ID of an existing subnet on OpenStack where you would like to launch the cluster. (Must be provided for **Use an existing subnet in an existing network**)

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
