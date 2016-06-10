### Example

The following example creates a hadoop cluster with `hdp-small-default` blueprint on `m1.large` instances with 2X100G
 attached disks on `osnetwork` network using `all-services-port` security group. You should copy your ssh public key 
 file into your `cbd` working directory with name `id_rsa.pub` and change the `<...>` parts with your OpenStack 
 credential and network details.

```
credential create --OPENSTACK --name my-os-credential --description "credentail description" --userName <OpenStack username> --password <OpenStack password> --tenantName <OpenStack tenant name> --endPoint <OpenStack Identity Service (Keystone) endpoint> --sshKeyPath <path of your public SSH key file>
credential select --name my-os-credential
template create --OPENSTACK --name ostemplate --description openstack-template --instanceType m1.large --volumeSize 100 --volumeCount 2
blueprint select --name hdp-small-default
instancegroup configure --instanceGroup host_group_master_1 --nodecount 1 --templateName ostemplate --ambariServer true
instancegroup configure --instanceGroup host_group_master_2 --nodecount 1 --templateName ostemplate --ambariServer false
instancegroup configure --instanceGroup host_group_master_3 --nodecount 1 --templateName ostemplate --ambariServer false
instancegroup configure --instanceGroup host_group_client_1  --nodecount 1 --templateName ostemplate --ambariServer false
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName ostemplate --ambariServer false
network create --OPENSTACK --name osnetwork --description openstack-network --publicNetID <id of an OpenStack public network> --subnet 10.0.0.0/16
network select --name osnetwork
securitygroup select --name all-services-port
stack create --OPENSTACK --name my-first-stack --region local --wait true
cluster create --description "My first cluster" --wait true
```

**Congratulations!** Your cluster should now be up and running on this way as well. To learn more about Cloudbreak and 
provisioning, we have some [interesting insights](operations.md) for you.
