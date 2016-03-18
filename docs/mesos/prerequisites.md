## A working Mesos cluster with Marathon

It is not the scope of Cloudbreak to provision a new Mesos cluster so it needs an already working Mesos cluster where it will be able to start HDP clusters. It is also required to have Marathon installed because Cloudbreak uses its API to schedule Docker containers.

## Hostnames must be resolvable inside the Mesos cluster and also by Cloudbreak

Cloudbreak does not deploy a custom DNS solution like on other cloud providers, where Consul is used to provide addresses for every node. Containers are deployed with `net=host` and Mesos nodes must be set up manually in a way to be able to resolve each other's hostnames to IP addresses and vice versa with reserve DNS. This is a requirement of Hadoop and it is usually accomplished by setting up the `/etc/hosts` file on each node in the cluster, but it can also be provided by some DNS servers like Amazon's default DNS server in a virtual network.

Example:

- If you have 5 nodes in the Mesos cluster: `node1, node2, node3, node4 and node5` with private IP addresses of `10.0.0.1 to 10.0.0.5` respectively, the `/etc/hosts` file on `node1` should contain these entries:

```
	10.0.0.2 node2
	10.0.0.3 node3
	10.0.0.4 node4
	10.0.0.5 node5
```

## Docker must be install on Mesos slave nodes and Docker containerizer must be enabled

To be able to use the Docker containerizer, Docker must be installed on all the Mesos slave nodes. To install Docker, follow the instructions in their documentation [here](https://docs.docker.com/engine/installation/).

After Docker is installed, it can be configured for the Mesos slave, by adding the [Docker containerizer](http://mesos.apache.org/documentation/latest/docker-containerizer/) to each Mesos slave configuration. To configure it, add `docker,mesos` to the file `/etc/mesos-slave/containerizers` on each of the slave nodes (or start mesos-slave with the `--containerizers=mesos,docker` flag, or set the environment variable MESOS_CONTAINERIZERS="mesos,docker"). You may also want to increase the executor timeout to 10 mins by adding `10mins` to `/etc/mesos-slave/executor_registration_timeout` because it will allow time for pulling large Docker images.