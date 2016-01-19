# Azure Setup

On other cloud providers you can create “public images”, while on Azure its a different process. 
You have to create a publicly available virtual disk image (vhdi), which has to be downloaded and imported 
into a storage account. Our experience shows that it takes about 30-60 minutes until you can log into the VM.
Therefore we provider a much easier way based on a ResourceManager Template.

## Deploy via Azure web UI

It is as simple as clicking here: <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsequenceiq%2Fazure-cbd-quickstart%2Fmaster%2Fazuredeploy.json">  ![deploy on azure](http://azuredeploy.net/deploybutton.png) </a>

After that you have to wait about 15-20 minutes until the docker images are downloaded. Once its done, you can reach
the Cloudbreak UI on port 3000

## Under the hood

Meanwhile azure is creating the deployment, here is some background what happens:
- start from official CentOS, so no custom image copy is needed (which would take like 30 minutes)
- use [Docker VM Extension](https://github.com/Azure/azure-docker-extension) to install Docker
- use [CustomScript Extension](https://github.com/Azure/azure-linux-extensions/tree/master/CustomScript) to install Cloudbreak Deployer (cbd)

### Next steps

Once Cloudbreak is up and running you should check out the [Provisioning Prerequisites](azure_pre_prov.md) needed to create Azure
clusters with Cloudbreak.
