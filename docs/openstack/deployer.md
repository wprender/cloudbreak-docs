Before configuring Cloudbreak Deployer, you should know that:

  * The default SSH username for the OpenStack instances is `cloudbreak`.
  * Cloudbreak Deployer location on the launched EC2 instance is `/var/lib/cloudbreak-deployment`. This is the
  `cbd` root folder.
  * You must execute all `cbd` actions from the `cbd` root folder as a `cloudbreak` user.

## Set up Cloudbreak Deployer

You should have already installed the Cloudbreak Deployer either by [using the OpenStack Cloud Images](openstack.md) or by
[installing the Cloudbreak Deployer](onprem.md) manually on your own VM.

If you have your own installed VM, check the [Initialize your Profile](openstack.md#initialize-your-profile)
section here before starting the provisioning.

You can [connect to the previously created `cbd` VM](http://docs.openstack.org/user-guide/dashboard_launch_instances.html#connect-to-your-instance-by-using-ssh).

To open the `cloudbreak-deployment` directory, run:
```
cd /var/lib/cloudbreak-deployment/
```
This directory contains configuration files and the supporting binaries for Cloudbreak Deployer.

### Initialize Your Profile

First, initialize `cbd`:

```
cbd init
```
This will create a `Profile` file in the current directory. Open the `Profile` file and check the `PUBLIC_IP`.
The `PUBLIC_IP` is mandatory because it is used to access the Cloudbreak UI. In some cases the `cbd` tool tries to
guess it. If `cbd` cannot get the IP address during the initialization, set the appropriate value.

### OpenStack-specific Configuration

Make sure that the [VM image used by Cloudbreak is imported on your OpenStack](openstack.md#cloudbreak-import).

## Using Self-signed Certificates
If your OpenStack is secured with a self-signed certificate, you need to import that certificate into Cloudbreak, 
or else Cloudbreak won't be able to communicate with your OpenStack. To import the certificate, place the certificate 
file in the generated certs directory `/certs/trusted/`. The trusted directory does not exist by default, so you need to create it.
Cloudbreak will automatically pick up these certificates and import them into its truststore upon start.

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
>If you need to run `cbd update`, refer to [Cloudbreak Deployer Update](update.md#update-cloudbreak-deployer).

- Cloudbreak Application logs:
```
   cbd logs cloudbreak
```
>You should see a line like this: `Started CloudbreakApplication in 36.823 seconds`. Cloudbreak normally takes less than a minute to start.
