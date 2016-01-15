# Azure Setup

## Setup Cloudbreak Deployer

To install and configure the Cloudbreak Deployer on Azure, start
a [Docker on Ubuntu Server](https://azure.microsoft.com/en-us/marketplace/partners/canonicalandmsopentech/dockeronubuntuserver1404lts/) VM on Azure.

Make sure you opened the following ports:

 * SSH (22)
 * Ambari (8080)
 * Identity server (8089)
 * Cloudbreak UI (3000)
 * User authentication (3001)
 * Autoscaling (8085)

Please log in to the machine with SSH or use username and password authentication (the following example shows how to ssh into the machine):

```
ssh -i <azure-ssh-pem-file> <username>@<virtual-machine-ip>
```

Install `unzip` on the machine:

```
sudo apt-get install unzip
```

Download **cloudbreak-deployer**:

```
curl -Ls public-repo-1.hortonworks.com/HDP/cloudbreak/cloudbreak-deployer_1.1.0_$(uname)_x86_64.tgz | sudo tar -xz -C /bin cbd
```

Check the cbd version running:

```
cbd --version
```

### Initialize your Profile

First initialize cbd by creating a `Profile` file:

```
cbd init
```

It will create a `Profile` file in the current directory. Please edit the file - the only required
configuration is the `PUBLIC_IP`. This IP will be used to access the Cloudbreak UI
(called Uluwatu). In some cases the `cbd` tool tries to guess it, if can't than will give a hint. 

```
echo export PUBLIC_IP=1.2.3.4 > Profile
```

### Start Cloudbreak

To start the Cloudbreak application use the following command.
This will start all the Docker containers and initialize the application. It will take a few minutes until all the services start.

```
cbd start
```

>Launching it first will take more time as it downloads all the Docker images needed by Cloudbreak.

The `cbd start` command includes the `cbd generate` command which applies the following steps:

- creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
- creates the **uaa.yml** file that holds the configuration of the identity server used to authenticate users to Cloudbreak.

After the `cbd start` command finishes you can check the logs of the Cloudbreak server with this command:

```
cbd logs cloudbreak
```
>Cloudbreak server should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`

### Next steps

Once Cloudbreak is up and running you should check out the [Provisioning Prerequisites](azure_pre_prov.md) needed to create Azure
clusters with Cloudbreak.
