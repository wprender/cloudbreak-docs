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

## Selected Ambari Server node

This instance has some special tasks:

- it runs the Ambari server and its database
- it runs an nginx proxy that is used by the Cloudbreak API to communicate with the cluster securely
- it runs a Kerberos KDC container if Kerberos is configured

**Logs**

*Hadoop logs*

Hadoop logs are available from the host and from the container as well in the `/hadoopfs/fs1/logs` directory.

*Ambari logs*

You can check the Ambari logs on the host instance under the ``/hadoopfs/fs1/logs` folder as well.

**Ambari database**

To access Ambari's database SSH to the selected node and run the following command:


## Proxy settings

### For the cbd

The following configs needs to be added to your `Profile`:

```
export CB_HTTP_PROXY="http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export CB_HTTPS_PROXY="http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export CB_JAVA_OPTS="-Dhttp.proxyHost=YOUR_PROXY_ADDRESS -Dhttp.proxyPort=YOUR_PROXY_PORT -Dhttps.proxyHost=YOUR_PROXY_ADDRESS -Dhttps.proxyPort=YOUR_PROXY_PORT -Dhttp.nonProxyHosts=172.17.0.1|*.service.consul|*.node.dc1.consul"
```

### For Docker

To download newer Docker images from the official repository the proxy settings should also be configured for the Docker service. It could be done through configuring the 'HTTP_PROXY' variable in your environment then the docker service should be restarted.
> **NOTE** [Related related part of the Docker documentation](https://docs.docker.com/engine/admin/systemd/#/http-proxy)


### For the provisioned clusters

If the cluster would like to be provisioned to a (virtual) network that is behind a proxy then the `yum` on the provisioned machines needs to be configured to use that proxy. This is important because the Ambari install needs access to public repositories. The proxy settings of the `yum` could be configured by using the recipe functionality of Cloudbreak. A 'pre' recipe that will run on all of the nodes before the Ambari install begins needs to be created with the following `bash` script:
```
#!/bin/bash
cat >> /etc/yum.conf <<ENDOF

proxy=http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT

ENDOF
```

### Useful

We created a `CURL` command that could be used for testing your proxy settings:
```
https_proxy="YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT" curl -X GET -I --insecure https://cloudbreak-api.sequenceiq.com/info
```
It's result should start with:
```
HTTP/1.1 200 OK
```