## Cloudbreak Deployer AWS Image Details

> **[Minimum and Recommended VM requirements](onprem.md#minimum-and-recommended-system-requirements):** 8GB RAM, 10GB disk, 2 cores (The minimum instance type which is fit for cloudbreak is **m3.large**)

**Cloudbreak Deployer Highlights**

  * The default SSH username for the EC2 instances is `cloudbreak`.
  * Cloudbreak Deployer location is `/var/lib/cloudbreak-deployment` on the launched EC2 instance. This is the
  `cbd` root folder there.
  * All `cbd` actions must be executed from the `cbd` root folder as `cloudbreak` user.

## Setup Cloudbreak Deployer

You should already have the Cloudbreak Deployer either by [using the AWS Cloud Images](aws.md) or by [installing the
Cloudbreak Deployer](onprem.md) manually on your own VM.

If you have your own installed VM, you should check the [Initialize your Profile](aws.md#initialize-your-profile)
section here before starting the provisioning.

You can [connect to the previously created `cbd` VM](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html).

To open the `cloudbreak-deployment` directory:

```
cd /var/lib/cloudbreak-deployment/
```
This is the directory of the configuration files and the supporting binaries for Cloudbreak Deployer.

### Initialize your Profile

First initialize `cbd` by creating a `Profile` file:

```
cbd init
```
It will create a `Profile` file in the current directory. Please open the `Profile` file then check the `PUBLIC_IP`.
This is mandatory, because of to can access the Cloudbreak UI (called Uluwatu). In some cases the `cbd` tool tries to
guess it. If `cbd` cannot get the IP address during the initialization, please set the appropriate value.

### AWS specific configuration

**AWS Account Keys**

There are 2 ways to create AWS credentials in Cloudbreak. 

* Key-based: It requires your AWS access and secret key and Cloudbreak will use this key to launch the resources. This key needs to be provided when you create your credential in Cloudbreak either with Cloudbreak UI or Cloudbreak CLI.
* Role-based: It requires a valid IAM User role and Cloudbreak will assume this role to get a temporary access and secret key. For this action you need to set your AWS key in the `Profile` file.
We suggest to use the keys of a valid **IAM User** here.

```
export AWS_ACCESS_KEY_ID=AKIA**************W7SA
export AWS_SECRET_ACCESS_KEY=RWCT4Cs8******************/*skiOkWD
```
## Start Cloudbreak Deployer

To start the Cloudbreak application use the following command.
This will start all the Docker containers and initialize the application.

```
cbd start
```

>At the very first time it will take for a while, because of need to download all the necessary docker images.

The `cbd start` command includes the `cbd generate` command which applies the following steps:

- creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
- creates the **uaa.yml** file that holds the configuration of the identity server which is used to authenticate users to Cloudbreak.

## Validate the started Cloudbreak Deployer

After the `cbd start` command finishes followings are worthy to check:

- Pre-installed Cloudbreak Deployer version and health:
```
   cbd doctor
```
>In case of `cbd update` is needed, please check the related documentation for [Cloudbreak Deployer Update](operations.md#update-cloudbreak-deployer).

- Started Cloudbreak Application logs:
```
   cbd logs cloudbreak
```
>Cloudbreak should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`
