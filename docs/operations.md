# Operations

## Debug

If you want to have more detailed output set the `DEBUG` env variable to non-zero:

```
DEBUG=1 cbd some_command
```

## Troubleshoot

You can use the `doctor` command to diagnose your environment.
It can reveal some common problems with your docker or boot2docker configuration and it also checks the cbd versions.

```
cbd doctor
```

## Logs

The aggregated logs of all the Cloudbreak components can be checked with:

```
cbd logs
```

It can also be used to check the logs of an individual docker container. To see only the logs of the Cloudbreak backend:

```
cbd logs cloudbreak
```

You can also check the individual logs of `uluwatu`, `periscope`, and `identity`.

## Update Cloudbreak Deployer

The cloudbreak-deployer tool is capable of upgrading itself to a newer version.

Please apply the following steps on the console:

- Update Cloudbreak Deployer
```
   cbd update
```
- Update the `docker-compose.yml` file with new Docker containers that are needed for the `cbd`
```
   cbd regenerate
```
- Start the new version of the `cbd`
```
   cbd start
```
> It will take for a while, because of need to download all the updated docker images for the new version.

- Check the health and version of the updated `cbd`
```
   cbd doctor
```
- Check the started Cloudbreak Application logs
```
   cbd logs cloudbreak
```
>Cloudbreak should start within a minute - you should see a line like this: `Started CloudbreakApplication in 36.823 seconds`

## SSH to the hosts

In the current version of Cloudbreak all the nodes can have a public IP address and all the nodes can be accessible via SSH.
The public IP addresses of a running cluster can be checked on the Cloudbreak UI under the *Nodes* tab.
Only key-based authentication is supported - the public key can be specified when creating a cloud credential.

Each cloud provider has different SSH user. In order to figure out the username you can try it wit the `root` user - that will tell you the correct username.

As an example:

```
ssh -i ~/.ssh/private-key.pem USER_NAME@<public-ip>
```

## Accessing HDP client services

The main difference between general HDP clusters and Cloudbreak-installed HDP clusters is that each host runs an Ambari server or agent Docker container and the HDP services will be installed in this container as well.
It means that after `ssh` the client services won't be available instantly, first you'll have to `enter` the ambari-agent container.
Inside the container everything works the same way as expected. In order to do so there are a few options.

## Data volumes

The disks that are attached to the instances are automatically mounted to `/hadoopfs/fs1`, `/hadoopfs/fs2`, ... `/hadoopfs/fsN` respectively.

## Cloudbreak gateway node

With every Cloudbreak cluster installation there is a special node called *cbgateway* started that won't run an ambari-agent container so it won't run HDP services either.
It can be seen on the Cloudbreak UI among the hostgroups when creating a cluster, but its node count cannot be changed from 1 and it shouldn't be there in the Ambari blueprint.
It is by design because this instance has some special tasks:

- it runs the Ambari server and its database
- it runs an nginx proxy that is used by the Cloudbreak API to communicate with the cluster securely
- it runs a Kerberos KDC container if Kerberos is configured

**Logs**

*Hadoop logs*

Hadoop logs are available from the host and from the container as well in the `/hadoopfs/fs1/logs` directory.

*Ambari logs*

You can check the Ambari logs on the host instance under the ``/hadoopfs/fs1/logs` folder as well.

**Ambari database**

Ambari's database runs on the `cbgateway`. To access it SSH to the `gateway` node and run the following command:
