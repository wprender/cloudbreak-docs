We have pre-built Cloudbreak Deployer cloud image for Google Cloud Platform (GCP). You can launch the latest 
Cloudbreak Deployer image at the [Google Developers Console](https://console.developers.google.com/).

> Alternatively, instead of using the pre-built cloud images for GCP, you can install Cloudbreak Deployer on your own
 VM. See [installation page](onprem.md) for more information.

Please make sure you added the following ports to your firewall rules:
 
 * SSH (22)
 * Cloudbreak API (8080)
 * Identity server (8089)
 * Cloudbreak GUI (3000)
 * User authentication (3001)

## Cloudbreak Deployer GCP Image Details

### Import Cloudbreak Deployer Image

You can import the latest Cloudbreak Deployer image on the [Google Developers Console](https://console.developers.google.com/) with the help
 of the [Google Cloud Shell](https://cloud.google.com/cloud-shell/docs/).
 
Just click on the `Activate Google Cloud Shell` icon in the top right corner of the page:
 
![](/gcp/images/google-cloud-shell-button.png)
<sub>*Full size [here](/gcp/images/google-cloud-shell-button.png).*</sub>

**Images are global resources, so you can use these across zones and projects.**
![](/gcp/images/google-cloud-shell_v2.png)
<sub>*Full size [here](/gcp/images/google-cloud-shell_v2.png).*</sub>

You can **create your own Cloudbreak Deployer (cbd) instance from the imported image** on the Google Developers Console.

> **[Minimum and Recommended VM requirements](onprem.md#minimum-and-recommended-system-requirements):** 4GB RAM, 10GB disk, 2 cores