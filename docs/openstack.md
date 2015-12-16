#OpenStack Setup

## Setup Cloudbreak Deployer

> This feature is currently `TECHNICAL PREVIEW` and is available for the `OpenStack Juno` release.

If you already have Cloudbreak Deployer either by [using the OpenStack Cloud Images](openstack-image.md) or by [installing the Cloudbreak Deployer](onprem.md) manually on your own VM,
you can start to setup the Cloudbreak Application with the deployer.

Create and open the `cloudbreak-deployment` directory:

```
cd cloudbreak-deployment
```

This is the directory of the config files and the supporting binaries that will be downloaded by Cloudbreak deployer.

###Initialize your Profile

First initialize your directory by creating a `Profile` file:

```
cbd init
```

It will create a `Profile` file in the current directory. Please edit the file - one of the required configurations is the `PUBLIC_IP`.
This IP will be used to access the Cloudbreak UI (called Uluwatu). In some cases the `cbd` tool tries to guess it, if can't than will give a hint.

The other required configuration in the `Profile` is the name of the Cloudbreak image you uploaded to your OpenStack cloud.

```
export CB_OPENSTACK_IMAGE="$OS_IMAGE_NAME"
```

###Start Cloudbreak

To start the Cloudbreak application use the following command.
This will start all the Docker containers and initialize the application. It will take a few minutes until all the services start.

```
cbd start
```

>Launching it first will take more time as it downloads all the docker images needed by Cloudbreak.

The `cbd start` command includes the `cbd generate` command which applies the following steps:

- creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
- creates the **uaa.yml** file that holds the configuration of the identity server used to authenticate users to Cloudbreak.


After the `cbd start` command finishes you can check the logs of the Cloudbreak server with this command:

```
cbd logs cloudbreak
```
>Cloudbreak server should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`

###Next steps

Once Cloudbreak is up and running you should check out the [Provisioning Prerequisites](openstack_pre_prov.md) needed to create OpenStack clusters with Cloudbreak.
