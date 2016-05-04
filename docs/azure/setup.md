On other cloud providers, we provide “public images” that are pre-built with the Cloudbreak Deployer. But on Azure, its a different process.
We provide a way to launch Cloudbreak Deployer based on the new [Azure Resource Manager
Templates](https://github.com/Azure/azure-quickstart-templates).

## Deploy using the Azure Portal

To get started using the Azure Resource Manager template to install Cloudbreak, it is as simple as clicking here: <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsequenceiq%2Fazure-cbd-quickstart%2F1.2.2%2Fazuredeploy.json">  ![deploy on azure](http://azuredeploy.net/deploybutton.png) </a>

> **[Minimum and Recommended VM requirements](onprem.md#minimum-and-recommended-system-requirements):** 8GB RAM, 10GB disk, 2 cores (The minimum instance type which is fit for cloudbreak is **D2**)

**The following parameters are mandatory (beyond to the default values) for the new `cbd` Template!**

On the `Custom deployment` panel:

  * Please create a new `Resource group`
  * Select an appropriate `Resource group location`

On the `Parameters` panel:

  * Select the same `LOCATION` as for the resource group
  * `PASSWORD` must be between 6-72 characters long and must satisfy
  at least 3 of password complexity requirements from the following:
    * Contains an uppercase character
    * Contains a lowercase character
    * Contains a numeric digit
    * Contains a special character

**Finally** you should review the `Legal terms` from the `Custom deployment` panel:

  * If you agree with the terms and conditions, just click on `Create`
button of this panel
  * Also click on the `Create` button on the `Custom deployment`

> Deployment takes about **15-20 minutes**. You can track the
progress on the resource group details. If any issue has occurred, open the `Audit logs` from the settings.
> We have faced an interesting behaviour on the Azure Portal: [All operations were successful on template deployment,
but overall fail](https://github.com/Azure/azure-quickstart-templates/issues/1294).

  * Once it's successful done, you can reach the Cloudbreak UI
at:```http://<VM Public IP>:3000/```
    * email: admin@example.com
    * password: cloudbreak

## Under the hood

Meanwhile Azure is creating the deployment, here is some information about what happens in the background:

  * Start an instance from the official CentOS image
    * So no custom image copy is needed, which would take about 30
   minutes
  * Use [Docker VM Extension](https://github.com/Azure/azure-docker-extension) to install Docker
  * Use [CustomScript Extension](https://github.com/Azure/azure-linux-extensions/tree/master/CustomScript) to install
Cloudbreak Deployer (`cbd`)

**Cloudbreak Deployer Highlights**

  * The default SSH username for the Azure VMs is `cloudbreak`.
  * Cloudbreak Deployer location is `/var/lib/cloudbreak-deployment` on the launched `cbd` VM. This is the
      `cbd` root folder there.
  * All `cbd` actions must be executed from the `cbd` root folder.
  * Most of the `cbd` commands require `root` permissions. So it would be worth if you apply the `sudo su`.

## Validate the started Cloudbreak Deployer

- SSH to the launched Azure VM.

- Most of the `cbd` commands require `root` permissions. So it would be worth if you apply the:
```
  sudo su
```
> This is a MUST on Azure because the [Customscript Extension](https://github.com/Azure/azure-linux-extensions/tree/master/CustomScript) which basically creates everything running as sudo and this is not modifiable.

- Open the `cloudbreak-deployment` directory:
```
  cd /var/lib/cloudbreak-deployment
```

- Pre-installed Cloudbreak Deployer version and health:
```
  cbd doctor
```
>In case of `cbd update` is needed, please check the related documentation for [Cloudbreak Deployer Update](operations.md#update-cloudbreak-deployer). Most of the `cbd` commands require `root` permissions.

- Started Cloudbreak Application logs:
```
   cbd logs cloudbreak
```
>Cloudbreak should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`
