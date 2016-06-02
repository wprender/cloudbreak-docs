Before setting up Cloudbreak Deployer, you should know that:

  * The default SSH username for the EC2 instances is `cloudbreak`.
  * Cloudbreak Deployer location on your EC2 instance is `/var/lib/cloudbreak-deployment`. This is the
  `cbd` root folder.
  * You must execute all `cbd` actions from the `cbd` root folder as a `cloudbreak` user.

## Set up Cloudbreak Deployer

You should have already installed the Cloudbreak Deployer either [using the AWS Cloud Images](aws.md) or by [installing the
Cloudbreak Deployer](onprem.md) manually on your own VM.

If you used your own VM, check the [Initialize your Profile](aws.md#initialize-your-profile)
section here before starting the provisioning.

You can [connect to the previously created `cbd` VM](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html).

To open the `cloudbreak-deployment` directory, run:

```
cd /var/lib/cloudbreak-deployment/
```
This directory contains configuration files and the supporting binaries for Cloudbreak Deployer.

### Initialize your Profile

First initialize `cbd` by creating a `Profile` file:

```
cbd init
```
This will create a `Profile` file in the current directory. Open the `Profile` file and check the `PUBLIC_IP`. Cloudbreak UI uses the `PUBLIC_IP` to access the Cloudbreak UI. In some cases, the `cbd` tool tries to guess it. If `cbd` did not get the IP address during the initialization, set the appropriate value.

### Perform AWS-Specific Configurations

**AWS Account Keys**

There are two ways to create AWS credentials in Cloudbreak:

* **Key-based:** This requires your AWS access key and secret key pair. Cloudbreak will use these keys to launch the resources. Provide the keys when you create your credentials in Cloudbreak either with Cloudbreak UI or Cloudbreak CLI.
* **Role-based:** This requires a valid IAM User role (We suggest that you use keys of a valid **IAM User**). Cloudbreak will assume this role to get a temporary access and secret key pair. To set your AWS keys in the `Profile` file, add these lines:

  ```
  export AWS_ACCESS_KEY_ID=AKIA**************W7SA
  export AWS_SECRET_ACCESS_KEY=RWCT4Cs8******************/*skiOkWD
  ```
  
> If you want to use instance profile, do not set these variables. If you want to use Cloudbreak with Role ARNs instead of keys, make sure that the instance profile role can assume roles on AWS.

**Custom Tags**

In order to differentiate launched instances, we give you the option to use custom tags on your AWS resources deployed by Cloudbreak. You can use the tagging mechanism with the following variables. 

If you want just one custom tag on your Cloudformation resources, set this variable :

```
export CB_AWS_DEFAULT_CF_TAG=whatever
```
Then the name of the tag will be `CloudbreakId` and the value will be `whatever`.

If you need more specific tagging, set this variable:

```
export CB_AWS_CUSTOM_CF_TAGS=myveryspecifictag:veryspecific
```
Then the name of the tag will be `myveryspecifictag` and the value will be `veryspecific`. You can specify a list of tags here with a comma separated list; for example: `tag1:value1,tag2:value2,tag3:value3`.

## Start Cloudbreak Deployer

To start the Cloudbreak application use the following command:

```
cbd start
```
This will start all the Docker containers and initialize the application.

> The first time you start the Coudbreak app, the process will take longer than usual due to the download of all the necessary docker images.

The `cbd start` command includes the `cbd generate` command which applies the following steps:

* Creates the **docker-compose.yml** file that describes the configuration of all the Docker containers needed for the Cloudbreak deployment.
* Creates the **uaa.yml** file that holds the configuration of the identity server used to authenticate users to Cloudbreak.

## Validate that Cloudbreak Deployer Has Started

After the `cbd start` command finishes, check the following:

* Pre-installed Cloudbreak Deployer version and health:
   ```
   cbd doctor
   ```
 > In case `cbd update` is needed, check documentation for [Cloudbreak Deployer Update](operations.md#update-cloudbreak-deployer).

* Cloudbreak Application logs:
   ```
   cbd logs cloudbreak
   ```
  You should see a message like this in the log: `Started CloudbreakApplication in 36.823 seconds`. Cloudbreak normally takes less than a minute to start.
