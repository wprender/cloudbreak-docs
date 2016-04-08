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
network create --GCP --name my-gcp-network --description "sample description"
```
Other available options here:

`--networkId` The Virtual Network Identifier of your network. This is an optional 
value and must be an ID of an existing GCP virtual network. If the identifier is provided, the subnet CIDR will be 
ignored and the existing network's CIDR range will be used.

`--publicInAccount` is true, all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

`--subnet` specified subnet which will be used by the cluster (will be created under the provisioning).

`--subnetId` if you have an existing subnet in the network then you can specify the id here and the cluster will use that existing subnet.

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

