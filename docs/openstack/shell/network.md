**Networks**

Your clusters can be created in their own **networks** or in one of your already existing one. If you choose an 
existing network, it is possible to create a new subnet within the network. The subnet's IP range must be defined in 
the `Subnet (CIDR)` field using the general CIDR notation. Here you can read more about [OpenStack networking](http://docs.openstack.org/liberty/networking-guide/intro-networking.html).

*Custom OpenStack Network*

If you'd like to deploy a cluster to your OpenStack network you'll have to **create a new network** template.

A network also can be used repeatedly to create identical copies of the same stack (or to use as a foundation to 
start a new stack).

>"Before launching an instance, you must create the necessary virtual network infrastructure...an instance uses a 
public provider virtual network that connects to the physical network infrastructure...This network includes a DHCP 
server that provides IP addresses to instances...The admin or other privileged user must create this network because 
it connects directly to the physical network infrastructure."

>Here you can read more about OpenStack [virtual network](http://docs.openstack.org/liberty/install-guide-rdo/launch-instance.html#create-virtual-networks) and [public provider network](http://docs.openstack.org/liberty/install-guide-rdo/launch-instance-networks-public.html).

```
network create --OPENSTACK --name my-os-network --description openstack-network --publicNetID <id of an OpenStack 
public network> --subnet 10.0.0.0/16
```

>**IMPORTANT**

>- In case of existing subnet all three parameters must be provided, with new subnet only two are required.
- Please make sure the defined subnet here doesn't overlap with any of your already deployed subnet in the
 network, because of the validation only happens after the cluster creation starts.
- In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

>**NOTE** The new networks are created on OpenStack only after the the cluster provisioning starts with the selected 
network template.

Other available options here:

`--networkId` This must be an ID of an existing OpenStack virtual network.

`--routerId` Your virtual network router ID (must be provided in case of existing virtual network).

`--subnetId` Your subnet ID within your virtual network. If the identifier is provided, the `Subnet 
(CIDR)` will be ignored. Leave it blank if you'd like to create a new subnet within the virtual network with the 
provided `Subnet (CIDR)` range.

`--publicInAccount` If it is true, all the users belonging to your account will be able to use this template to create clusters, but cannot delete it.

You can check whether the network was created successfully
```
network list
```
