# Azure Setup

On other cloud providers you can create “public images”, while on Azure its a different process. You have to create a 
publicly available virtual disk image (VHDI), which has to be downloaded and imported 
into a storage account.

Based on our experience usually it takes about 30-60 minutes until it gets copied and you can log into the VM.
Therefore we provide a much easier way to launch Cludbreak Deployer based on the new [Azure Resource Manager 
Templates](https://github.com/Azure/azure-quickstart-templates).

## Deploy using the Azure Portal

It is as simple as clicking here: <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsequenceiq%2Fazure-cbd-quickstart%2Fmaster%2Fazuredeploy.json">  ![deploy on azure](http://azuredeploy.net/deploybutton.png) </a>

**The following parameters are mandatory to be set (beyond to the default values) for the new CBD Template!**
On the `Custom deployment` panel:

1. Please create a new `Resource group` 
2. Select an appropriate `Resource group location`
On the `Parameters` panel:

3. Select the same `LOCATION` as for the resource group
4. `PASSWORD` must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements from the following:
   - Contains an uppercase character
   - Contains a lowercase character
   - Contains a numeric digit
   - Contains a special character.
Finally you should review the `Legal terms` on the `Custom deployment` panel:

5. If you agree with the terms and conditions, just click on `Create` button of this pane
6. Also click on the `Create` button on the `Custom deployment` 
> Deployment takes about **15-20 minutes**. You can track the progress on the resource group details. If any issue 
has occurred, open the `Audit logs` from the settings. 

7. Once it's successful done, you can reach the Cloudbreak UI at:```http://<VM Public IP>:3000/```
8. **Optional:** You can SSH to the VM and track the progress in the Cloudbreak logs (`cbd logs cloudbreak`)

## Under the hood

Meanwhile Azure is creating the deployment, here is some information about what happens in the background:

- Start an instance from the official CentOS image
 - So no custom image copy is needed, which would take about 30 minutes
- Use [Docker VM Extension](https://github.com/Azure/azure-docker-extension) to install Docker
- Use [CustomScript Extension](https://github.com/Azure/azure-linux-extensions/tree/master/CustomScript) to install 
Cloudbreak Deployer (cbd)

### Next steps

Once Cloudbreak is up and running you should check out the [Provisioning Prerequisites](azure_pre_prov.md) to create Azure
clusters with Cloudbreak.
