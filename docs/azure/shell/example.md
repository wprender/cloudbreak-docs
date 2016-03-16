### Example

The following example creates a hadoop cluster with `hdp-small-default` blueprint on Standard_D3 instances with 
2X100G attached disks on `default-azure-network` network using `all-services-port` security group. You should copy 
your ssh public key file into your `cbd` working directory with name `id_rsa.pub` and paste your Azure credentials in 
the parts with `<...>` highlight.

```
credential create --AZURE --description "credential description" --name myazurecredential --subscriptionId <your Azure subscription id> --appId <your Azure application id> --tenantId <your tenant id> --password <your Azure application password> --sshKeyPath id_rsa.pub
credential select --name myazurecredential
template create --AZURE --name azuretemplate --description azure-template --instanceType Standard_D3 --volumeSize 100 
--volumeCount 2
blueprint select --name hdp-small-default
instancegroup configure --instanceGroup cbgateway --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_master_1 --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_master_2 --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_master_3 --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_client_1  --nodecount 1 --templateName azuretemplate
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName azuretemplate
network select --name default-azure-network
securitygroup select --name all-services-port
stack create --name my-first-stack --region "West US"
cluster create --description "My first cluster"
```
