Before configuring Cloudbreak Deployer, you should know that:

  * All `cbd` actions must be executed from the `cbd` root folder.
  * Most of the `cbd` commands require `root` permissions, so you may want to apply `sudo su`.

## Cloudbreak Deployer Installation

#### Install CLoudbreak Deployer

First, [install the Cloudbreak Deployer](onprem.md) manually on a VM inside your Mesos cluster's private network.

If you have your own installed VM, check the [Initialize your Profile](mesos.md#initialize-your-profile) section here before starting the provisioning.

Open the `cloudbreak-deployment` directory:

```
cd cloudbreak-deployment
```
This directory contains configuration files and the supporting binaries for Cloudbreak Deployer.

#### Initialize your Profile

First initialize `cbd`:  
```
cbd init
```
This creates a `Profile` file in the current directory. Open the `Profile` file and check the `PUBLIC_IP`. 
The `PUBLIC_IP` is mandatory, because it is used to access the Cloudbreak UI. In some cases the `cbd` tool tries to 
guess it. If `cbd` cannot get the IP address during the initialization, set the appropriate value.

#### Start Cloudbreak Deployer

To start the Cloudbreak application use the following command:  
```
cbd start
```
This will start all the Docker containers and initialize the application. 

>The first time you start the Coudbreak app, the process will take longer than usual due to the download of all the necessary docker images.

The `cbd start` command includes the `cbd generate` command which applies the following steps:

- creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
- creates the **uaa.yml** file that holds the configuration of the identity server used to authenticate users to Cloudbreak.

#### Validate that Cloudbreak Deployer Has Started

After the `cbd start` command finishes, check the following:

- Pre-installed Cloudbreak Deployer version and health:
```
   cbd doctor
```
>If you need to run `cbd update`, refer to [Cloudbreak Deployer Update](update.md#update-cloudbreak-deployer). Most of the `cbd` commands require `root` permissions.

- Logs of the Cloudbreak Application:
```
   cbd logs cloudbreak
```
>You should see a mesage like this in the log: `Started CloudbreakApplication in 36.823 seconds`. Cloudbreak normally takes less than a minute to start.
