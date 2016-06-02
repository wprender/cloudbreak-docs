We have pre-built cloud images for AWS with the Cloudbreak Deployer pre-installed. Go to your [AWS Management Console](https://aws.amazon.com/console/) to launch the latest Cloudbreak Deployer image in your region.  

As an alternative to using the pre-built cloud images for AWS, you can install Cloudbreak Deployer on your own VM. For more information, see [installation page](onprem.md).

Make sure that you have opened the following ports on your [security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html):
 
 * SSH (22)
 * Cloudbreak API (8080)
 * Identity server (8089)
 * Cloudbreak UI (3000)
 * User authentication (3001)
 
## Cloudbreak Deployer AWS Image Details

> **[Minimum and Recommended VM requirements](onprem.md#minimum-and-recommended-system-requirements):** 8GB RAM, 10GB disk, 2 cores. 
> The minimum instance type which is suitable for Cloudbreak is **m3.large**.
> To learn about all requirements, see **[Minimum and Recommended VM requirements](onprem.md#minimum-and-recommended-system-requirements).

 
