**Cloudbreak Deployer Highlights**

  * The default SSH username for the GCP instances is `cloudbreak`.
  * Cloudbreak Deployer location is `/home/cloudbreak/cloudbreak-deployment/` on the launched `cbd` VM. This is the 
      `cbd` root folder there.
  * All `cbd` actions must be executed from the `cbd` root folder.
  * Most of the `cbd` commands require `root` permissions. So it would be worth if you apply the `sudo su`.

## Setup Cloudbreak Deployer

You should already have the Cloudbreak Deployer either by [using the GCP Cloud Images](gcp.md) or by [installing the 
Cloudbreak Deployer](onprem.md) manually on your own VM. (The minimum instance type which is fit for cloudbreak is **n1-standard-2**)

If you have your own installed VM, you should check the [Initialize your Profile](gcp.md#initialize-your-profile) 
section here before starting the provisioning.

You have several opportunities to [connect to the previously created `cbd` VM](https://cloud.google.com/compute/docs/instances/connecting-to-instance).

  * Cloudbreak Deployer location is `/home/cloudbreak/cloudbreak-deployment/`.
  * All `cbd` actions must be executed from the `cbd` folder.
  * Most of the `cbd` commands require `root` permissions. So `sudo su` here would be worth for you. 

Open the `cloudbreak-deployment` directory:

```
cd cloudbreak-deployment
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

## Start Cloudbreak Deployer

To start the Cloudbreak application use the following command.
This will start all the Docker containers and initialize the application.

```
cbd start
```

>At the very first time it will take for a while, because of need to download all the necessary docker images.

The `cbd start` command includes the `cbd generate` command which applies the following steps:

- creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
- creates the **uaa.yml** file that holds the configuration of the identity server used to authenticate users to Cloudbreak.

## Validate the started Cloudbreak Deployer

After the `cbd start` command finishes followings are worthy to check:

- Pre-installed Cloudbreak Deployer version and health.
```
   cbd doctor
```
>In case of `cbd update` is needed, please check the related documentation for [Cloudbreak Deployer Update](operations.md#update-cloudbreak-deployer). Most of the `cbd` commands require `root` permissions.

- Started Cloudbreak Application logs.
```
   cbd logs cloudbreak
```
>Cloudbreak should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`