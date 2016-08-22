# Basic Operations

## Debugging

To get more detailed commnad prompt output, set the `DEBUG` environment variable to non-zero:  

```
DEBUG=1 cbd <some_command>
```

## Troubleshooting

The `doctor` command helps you diagnose problems with your environment, such as common problems with your docker or boot2docker configuration. You can also use it to check cbd versions.  

```
cbd doctor
```

## Accessing Logs

- To check the aggregated logs for all the Cloudbreak components, use:  

```
cbd logs
```

You can also check the logs of an individual docker container. 

- To view only the logs of the Cloudbreak backend, use:

```
cbd logs cloudbreak
```

- You can check the individual logs of `uluwatu`, `periscope`, and `identity`. For example, to check the `uluwatu` logs, use:

```
cbd logs uluwatu
```


## SSH to the Hosts

To connect to a running VM through SSH, you need to know its public IP address and private key. 

You can find the IP addresses of all the running VMs in the Cloudbreak UI, on the **Cluster details** page, in the **Nodes** section. Only key-based authentication is supported. The private key that you need to use to access the VM is the counterpart of the public key that you specified when creating a cloud credential.

Cloudbreak creates a `cloudbreak` user which can be used to ssh into the box. This user has passwordless sudo rights.

For example:

```
ssh -i ~/.ssh/your-private-key.pem cloudbreak@<public-ip>
```

## Data Volumes

The disks that are attached to the instances are automatically mounted to `/hadoopfs/fs1`, `/hadoopfs/fs2`, ... , `/hadoopfs/fsN` respectively.

## Ambari Server Node

The instance that serves as an Ambari Server node performs a few special tasks:

- It runs the Ambari Server and its database.
- It runs an NGINX proxy that is used by the Cloudbreak API to securely communicate with the cluster.
- If Kerberos is configured, it runs a Kerberos KDC container.

#### Accessing Hadoop and Ambari Logs

You can access **Hadoop logs** from the host and from the container in the `/hadoopfs/fs1/logs` directory.

You can access **Ambari logs** from the host instance in the ``/hadoopfs/fs1/logs` folder.

## Proxy Settings

### For the cbd

To configure proxy settings for Cloudbreak Deployer, add the following configs to your `Profile`:

```
export http_proxy="http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export https_proxy="http(s)://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export CB_HTTP_PROXY="http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export CB_HTTPS_PROXY="http(s)://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT/"
export CB_JAVA_OPTS="-Dhttp.proxyHost=YOUR_PROXY_ADDRESS -Dhttp.proxyPort=YOUR_PROXY_PORT -Dhttps.proxyHost=YOUR_PROXY_ADDRESS -Dhttps.proxyPort=YOUR_PROXY_PORT -Dhttp.nonProxyHosts=172.17.0.1|*.service.consul|*.node.dc1.consul"
```

### For Docker

To download newer Docker images from the official repository, you need to configure proxy settings for the Docker service. You can do this by configuring the 'HTTP_PROXY' variable in your environment. Next, restart the docker service.
> **NOTE** For more information, see [Docker documentation](https://docs.docker.com/engine/admin/systemd/#/http-proxy)


### For Provisioned Clusters

For a cluster to be provisioned to a (virtual) network that is behind a proxy, the `yum` on the provisioned machines needs to be configured to use that proxy. This is important because the Ambari install needs access to public repositories. You can configure `yum` proxy settings by using the recipe functionality of Cloudbreak. Use the following `bash` script to create a 'pre' recipe that will run on all of the nodes before the Ambari install:

```
#!/bin/bash
cat >> /etc/yum.conf <<ENDOF

proxy=http://YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT

ENDOF
```

### Testing Your Proxy Settings

You can use the following `CURL` command to test your proxy settings:
```
https_proxy="YOUR_PROXY_ADDRESS:YOUR_PROXY_PORT" curl -X GET -I --insecure https://cloudbreak-api.sequenceiq.com/info
```
Its output should start with:
```
HTTP/1.1 200 OK
```
