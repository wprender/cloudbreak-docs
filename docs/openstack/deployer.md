**Cloudbreak Deployer Highlights**

  * The default SSH username for the OpenStack instances is `cloudbreak`.
  * Cloudbreak Deployer location is `/var/lib/cloudbreak-deployment` on the launched EC2 instance. This is the
  `cbd` root folder.
  * All `cbd` actions must be executed from the `cbd` root folder as `cloudbreak` user.

## Setup Cloudbreak Deployer

You should already have the Cloudbreak Deployer either by [using the OpenStack Cloud Images](openstack.md) or by
[installing the Cloudbreak Deployer](onprem.md) manually on your own VM.

If you have your own installed VM, you should check the [Initialize your Profile](openstack.md#initialize-your-profile)
section here before starting the provisioning.

You can [connect to the previously created `cbd` VM](http://docs.openstack.org/user-guide/dashboard_launch_instances.html#connect-to-your-instance-by-using-ssh).

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

### OpenStack specific configuration

Make sure that the [VM image used by Cloudbreak is imported on your OpenStack](openstack.md#cloudbreak-import).

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
>In case of `cbd update` is needed, please check the related documentation for [Cloudbreak Deployer Update](operations.md#update-cloudbreak-deployer).

- Started Cloudbreak Application logs.
```
   cbd logs cloudbreak
```
>Cloudbreak should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`
