### Example

The following example creates a hadoop cluster with `hdp-small-default` blueprint on M3Xlarge instances with 2X100G 
attached disks on `default-gcp-network` network using `all-services-port` security group. You should copy your ssh 
public key file (with name `id_rsa.pub`) and your GCP service account generated private key ( with name `gcp.p12`) into your `cbd` working 
directory and change the `<...>` parts with your GCP credential details.

```
credential create --GCP --description "my credential" --name my-gcp-credential --projectId <your gcp projectid> --serviceAccountId <your GCP service account mail address> --serviceAccountPrivateKeyPath gcp.p12 --sshKeyFile id_rsa.pub
credential select --name my-gcp-credential
template create --GCP --name gcptemplate --description gcp-template --instanceType n1-standard-4 --volumeSize 100 
--volumeCount 2
blueprint select --name hdp-small-default
instancegroup configure --instanceGroup host_group_master_1 --nodecount 1 --templateName gcptemplate --ambariServer true
instancegroup configure --instanceGroup host_group_master_2 --nodecount 1 --templateName gcptemplate --ambariServer false
instancegroup configure --instanceGroup host_group_master_3 --nodecount 1 --templateName gcptemplate --ambariServer false
instancegroup configure --instanceGroup host_group_client_1  --nodecount 1 --templateName gcptemplate --ambariServer false
instancegroup configure --instanceGroup host_group_slave_1 --nodecount 3 --templateName gcptemplate --ambariServer false
network select --name default-gcp-network
securitygroup select --name all-services-port
stack create --GCP --name my-first-stack --region us-central1 --wait true
cluster create --description "My first cluster" --wait true
```

**Congratulations!** Your cluster should now be up and running on this way as well. To learn more about Cloudbreak and 
provisioning, we have some [interesting insights](operations.md) for you.
