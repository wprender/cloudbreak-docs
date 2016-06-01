### Example

The following example creates a Hadoop cluster with `hdp-small-default` blueprint on M4Xlarge instances with 2X100G 
attached disks on `default-aws-network` network using `all-services-port` security group. You should copy your ssh 
public key file into your `cbd` working directory with name `id_rsa.pub` and paste your AWS credentials in the parts with `<...>` highlight.

```
credential create --AWS --description description --name my-aws-credential --roleArn <arn role> --sshKeyPath id_rsa.pub
credential select --name my-aws-credential
template create --AWS --name awstemplate --description aws-template --instanceType m4.xlarge --volumeSize 100 
--volumeCount 2
blueprint select --name hdp-small-default
instancegroup configure --instanceGroup host_group_master_1 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_master_2 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_master_3 --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_client_1  --nodecount 1 --templateName awstemplate
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName awstemplate
network select --name default-aws-network
securitygroup select --name all-services-port
stack create --name my-first-stack --region us-east-1
cluster create --description "My first cluster"
```

**Congratulations!** Your cluster should now be up and running on this way as well. To learn more about Cloudbreak and 
provisioning, we have some [interesting insights](operations.md) for you.