# Operations

## Debug

To get more detailed commnad prompt output, set the `DEBUG` env variable to non-zero:  

```
DEBUG=1 cbd <some_command>
```

## Troubleshoot

The `doctor` command helps you diagnose problems in your environment, such as common problems with your docker or boot2docker configuration. You can also use it to check cbd versions.  

```
cbd doctor
```

## View Logs

To check the aggregated logs of all the Cloudbreak components use:  

```
cbd logs
```

You can also check the logs of an individual docker container. To see only the logs of the Cloudbreak backend, use:

```
cbd logs cloudbreak
```

You can also check the individual logs of `uluwatu`, `periscope`, and `identity`. For example:

```
cbd logs uluwatu
```


## SSH to the Hosts

In the current version of Cloudbreak, all the nodes can have a public IP address and all the nodes can be accessible via SSH.
You can check the public IP addresses of a running cluster in the Cloudbreak UI under the *Nodes* tab.
Cloudbreak supports only key-based authentication; the public key can be specified when creating a cloud credential.

Each cloud provider has a different SSH user. In order to figure out the SSH user, you can try it with the `root` user - that will tell you the correct username.

For example:

```
ssh -i ~/.ssh/private-key.pem USER_NAME@<public-ip>
```

## Accessing HDP Client Services

The main difference between general HDP clusters and Cloudbreak-installed HDP clusters is that in Cloudbreak each host runs not only an Ambari server or agent, but also the HDP services in the same Docker container.
This means that after `ssh` the client services won't be available instantly. You will first have to `enter` the ambari-agent container.
Inside the container, everything works as expected. In order to do so there are a few options.

## Data Volumes

The disks that are attached to the instances are automatically mounted to `/hadoopfs/fs1`, `/hadoopfs/fs2`, ... `/hadoopfs/fsN` respectively.

## Ambari Server Node

The instance that serves as an Ambari server node performs a few special tasks:

- It runs the Ambari server and its database
- It runs an nginx proxy that is used by the Cloudbreak API to securely communicate with the cluster
- If Kerberos is configured, it runs a Kerberos KDC container 

**Logs**

*Hadoop Logs*

You can access Hadoop logs from the host and from the container in the `/hadoopfs/fs1/logs` directory.

*Ambari Logs*

You can access Ambari logs from the host instance in the ``/hadoopfs/fs1/logs` folder.

**Ambari Database**

To access Ambari's database, SSH to the selected node and run the following command:


## Proxy Settings

### For the cbd

Add the following configs to your `Profile`:

```
export http_proxy="http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export https_proxy="http(s)://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export CB_HTTP_PROXY="http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export CB_HTTPS_PROXY="http(s)://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export CB_JAVA_OPTS="-Dhttp.proxyHost=YOUR_PROXY_ADDRESS -Dhttp.proxyPort=YOUR_PROXY_PORT -Dhttps.proxyHost=YOUR_PROXY_ADDRESS -Dhttps.proxyPort=YOUR_PROXY_PORT -Dhttp.nonProxyHosts=172.17.0.1|*.service.consul|*.node.dc1.consul"
```

### For Docker

To download newer Docker images from the official repository, you need to configure the proxy settings for the Docker service. You can do this by configuring the 'HTTP_PROXY' variable in your environment. Next, restart the docker service.
> **NOTE** See [related Docker documentation](https://docs.docker.com/engine/admin/systemd/#/http-proxy)


### For Provisioned Clusters

For a cluster to be provisioned to a (virtual) network that is behind a proxy, the `yum` on the provisioned machines needs to be configured to use that proxy. This is important because the Ambari install needs access to public repositories. You can configure `yum` proxy settings by using the recipe functionality of Cloudbreak. Use the following `bash` script to create a 'pre' recipe that will run on all of the nodes before the Ambari install:
 
```
#!/bin/bash
cat >> /etc/yum.conf <<ENDOF

proxy=http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT

ENDOF
```

### Test Your Proxy Settings 

You can use the following `CURL` command to test your proxy settings:
```
https_proxy="YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT" curl -X GET -I --insecure https://cloudbreak-api.sequenceiq.com/info
```
Its output should start with:
```
HTTP/1.1 200 OK
```