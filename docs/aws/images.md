We have pre-built cloud images for AWS with the Cloudbreak Deployer pre-installed. You can launch the latest 
Cloudbreak Deployer image based on your region at the [AWS Management Console](https://aws.amazon.com/console/).

> Alternatively, instead of using the pre-built cloud images for AWS, you can install Cloudbreak Deployer on your own
 VM. See [installation page](onprem.md) for more information.

Please make sure you opened the following ports on your [security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html):
 
 * SSH (22)
 * Cloudbreak API (8080)
 * Identity server (8089)
 * Cloudbreak GUI (3000)
 * User authentication (3001)
 
## Cloudbreak Deployer AWS Image Details

> **[Minimum and Recommended VM requirements](onprem.md#minimum-and-recommended-system-requirements):** 8GB RAM, 10GB disk, 2 cores (The minimum instance type which is fit for cloudbreak is **m3.large**)

 