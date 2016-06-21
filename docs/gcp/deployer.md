Before configuring Cloudbreak Deployer, note that:

  * The default SSH username for the GCP instances is `cloudbreak`.
  * Cloudbreak Deployer location on the launched `cbd` VM is `/var/lib/cloudbreak-deployment`. This is the 
      `cbd` root folder.
  * You must execute all `cbd` actions from the `cbd` root folder.

## Set up Cloudbreak Deployer

You should already have the Cloudbreak Deployer either [using the GCP Cloud Images](gcp.md) or by [installing the 
Cloudbreak Deployer](onprem.md) manually on your own VM. (The minimum instance type suitable for cloudbreak is **n1-standard-2**)

If you have installed Cloudbreak Deployer on your own VM, check the [Initialize your Profile](gcp.md#initialize-your-profile) 
section here before starting the provisioning.

There are several ways to [connect to the previously created `cbd` VM](https://cloud.google.com/compute/docs/instances/connecting-to-instance).

Open the `cloudbreak-deployment` directory:

```
cd /var/lib/cloudbreak-deployment
```
This directory contains configuration files and the supporting binaries for Cloudbreak Deployer.

### Initialize Your Profile

First, initialize `cbd` by creating a `Profile` file:

```
cbd init
```
This will create a `Profile` file in the current directory. Open the `Profile` file and check the `PUBLIC_IP`. 
`PUBLIC_IP`is mandatory, because it is used to access the Cloudbreak UI. In some cases the `cbd` tool tries to 
guess it. If `cbd` cannot get the IP address during the initialization, set the appropriate value.

## Start Cloudbreak Deployer

To start the Cloudbreak application, use the following command:
```
cbd start
```
This will start all the Docker containers and initialize the application.

>The first time you start the Coudbreak app, the process will take longer than usual due to the download of all the necessary docker images.

The `cbd start` command includes the `cbd generate` command which applies the following steps:

- creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
- creates the **uaa.yml** file that holds the configuration of the identity server used to authenticate users to Cloudbreak.

## Validate that Cloudbreak Deployer Has Started

After the `cbd start` command finishes, check the following:

- Pre-installed Cloudbreak Deployer version and health:
```
   cbd doctor
```
>If you need to run `cbd update`, refer to [Cloudbreak Deployer Update](update.md#update-cloudbreak-deployer). Most of the `cbd` commands require `root` permissions.

- Started Cloudbreak Application logs:
```
   cbd logs cloudbreak
```
>You should see a line like this in the log: `Started CloudbreakApplication in 36.823 seconds`. Cloudbreak normally takes less than a minute to start.

