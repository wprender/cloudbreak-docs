# Install Cloudbreak Deployer

To install Cloudbreak Deployer on your selected environment you have to follow the steps below. The instruction 
describe a CentOS based installation.

## Minimum and Recommended System Requirements

To run the Cloudbreak Deployer and install the Cloudbreak Application, you must meet the following requirements:

  * RHEL / CentOS / Oracle Linux 7 (64-bit)
  * Docker 1.9.1
  * Minimum and Recommended VM requirements:
    * 4GB RAM
    * 10GB disk
    * 2 cores

> You can install Cloudbreak on **Mac OS X for evaluation purposes only**. This operating system is not supported 
for a production deployment of Cloudbreak.

Make sure you opened the following ports:

 * SSH (22)
 * Cloudbreak API (8080)
 * Identity server (8089)
 * Cloudbreak GUI (3000)
 * User authentication (3001)

Every command shall be executed as **root**. In order to get root privileges execute:

```
sudo -i
```

Ensure that your system is up-to date and reboot if necessary (e.g. there was a kernel update)  :

```
yum -y update
```

You need to install iptables-services, otherwise the 'iptables save' command will not be available:

```
yum -y install iptables-services net-tools
```

Please configure permissive iptables on your machine:

```
iptables --flush INPUT && \
iptables --flush FORWARD && \
service iptables save
```

Configure a custom Docker repository for installing the correct version of Docker:

```
cat > /etc/yum.repos.d/docker.repo <<"EOF"
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```

Then you are able to install the Docker service:

```
yum install -y docker-engine-1.9.1 docker-engine-selinux-1.9.1
systemctl start docker
systemctl enable docker
```

## Install Cloudbreak Deployer

Install the Cloudbreak Deployer and unzip the platform specific single binary to your PATH. The one-liner way is:

```
yum -y install unzip tar
curl -Ls public-repo-1.hortonworks.com/HDP/cloudbreak/cloudbreak-deployer_1.2.0_$(uname)_x86_64.tgz | sudo tar -xz -C /bin cbd
cbd --version
```

Once the Cloudbreak Deployer is installed, you can start to setup the Cloudbreak application.

## Initialize your Profile

First initialize `cbd` by creating a `Profile` file:

```
mkdir cloudbreak-deployment
cd cloudbreak-deployment
cbd init
```

It will create a `Profile` file in the current directory. Please edit the file - the only required
configuration is the `PUBLIC_IP`. This IP will be used to access the Cloudbreak UI
(called Uluwatu). In some cases the `cbd` tool tries to guess it, if can't than will give a hint.

## Generate your Profile

You are done with the configuration of Cloudbreak Deployer. The last thing you have to do is to regenerate the configurations in order to take effect.

```
rm *.yml
cbd generate
```

This command applies the following steps:

- creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
- creates the **uaa.yml** file that holds the configuration of the identity server used to authenticate users to Cloudbreak.

## Start Cloudbreak

To start the Cloudbreak application use the following command.
This will start all the Docker containers and initialize the application. It will take a few minutes until all the services start.

```
cbd pull
cbd start
```

>At the very first time it will take for a while, because of need to download all the necessary docker images.

After the `cbd start` command finishes you can check the logs of the Cloudbreak application with this command:

```
cbd logs cloudbreak
```
>Cloudbreak should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`


## Troubleshooting

If you are faced with permission or connection issue, first you can try to disable **SELinux**:
  
  1. Setting the `SELINUX=disabled` in `/etc/selinux/config`
  2. Reboot the machine
  3. Ensure the SELinux is not turned on after
    
```
setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```
## Next steps

Now you have all the pre-requisites for Cloudbreak. You can follow with the **cloud provider specific** configuration. Select one of the provider in the header 
then follow the steps from the **Setup** section:

 * [AWS](aws.md#aws-setup)
 * [Azure](azure.md)
 * [GCP](gcp.md#google-setup)
 * [OpenStack](openstack.md#openstack-setup)

> **Note!** AWS and OpenStack Setup sections contain additional and provider specific `Profile` settings.