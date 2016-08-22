#### Networks

Your clusters can be created in their own **networks** or in one of your already existing one. If you choose an 
existing network, it is possible to create a new subnet within the network. The subnet's IP range must be defined in 
the `Subnet (CIDR)` field using the general CIDR notation.

*Default AZURE Network*

If you don't want to create or use your custom network, you can use the `default-azure-network` for all your 
Cloudbreak clusters. It will create a new network with a `10.0.0.0/16` subnet and `10.0.0.0/8` address prefix every 
time a cluster is created.

*Custom AZURE Network*

If you'd like to deploy a cluster to a custom network you'll have to apply the following command:
```
network create --AZURE --name my-azure-network --addressPrefix 192.168.123.123 --subnet 10.0.0.0/16
```

>**IMPORTANT:** Make sure the defined subnet and theirs address prefixes here doesn't overlap with any of your 
already deployed subnet and its already used address prefix in the network, because of the validation only happens 
after the cluster creation 
starts.
   
>In case of existing subnet make sure you have enough room within your network space for the new instances. The 
provided subnet CIDR will be ignored, but a proper CIDR range will be used.

You can check whether the network was created successfully
```
network list
```

`--addressPrefix` This list will be appended to the current list of address prefixes.

- The address prefixes in this list should not overlap between them.
- The address prefixes in this list should not overlap with existing address prefixes in the network.

You can find more details about the AZURE Address Prefixes [here](https://azure.microsoft.com/en-us/documentation/articles/azure-cli-arm-commands/#azure-network-commands-to-manage-network-resources).

If `--publicInAccount` is true, all the users belonging to your account will be able to use this network template 
to create clusters, but cannot delete it.

>**NOTE:** The new networks are created on AZURE only after the the cluster provisioning starts with the selected 
network template.

