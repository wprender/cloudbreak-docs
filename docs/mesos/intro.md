> Mesos support is currently `TECHNICAL PREVIEW`. It may not be suitable for production use.

 The basic concepts of Cloudbreak's Mesos support are the same as the other other cloud provider implementations: HDP clusters will be provisioned through Ambari with the help of blueprints and Ambari server and agents run in Docker containers. But it has a lot of major differences, and to start working with Cloudbreak on Mesos these differences must be understood first.

## Differences with the cloud provider implementations

####1. The Mesos integration doesn't start new instances and doesn't build a new infrastructure on a cloud provider.

Cloudbreak's normal behavior is to build the infrastructure first where Hadoop components will be deployed later through Ambari. It involves creating or reusing the networking layer like virtual networks and subnets, provisioning new virtual machines in these networks from pre-existing cloud images and starting the Ambari docker containers on these nodes. Mesos integration was designed *not* to include these steps because in most cases users already have their own Mesos infrastructure and would like to deploy their cluster there, near their other components. That's why Cloudbreak expects to "bring your own Mesos infrastructure" and configure access to this Mesos deployment in Cloudbreak first.

####2. A Mesos credential on the Cloudbreak UI means configuring access to the Marathon API.

Cloudbreak needs a control system in Mesos through which it can communicate and start Ambari containers. The standard application scheduling framework for services in Mesos is Marathon so we've chosen it as the solution for Cloudbreak. It means that to be able to communicate with Mesos, Cloudbreak needs a Marathon deployment on the Mesos cluster. When setting up access in Cloudbreak a Marathon API endpoint must be specified. Basic authentication and TLS on the Marathon API is not yet supported in the tech preview.

####3. A Mesos template on the Cloudbreak UI means constraints instead of new resources.

Cloudbreak templates describe the virtual machines in a cluster's hostgroup that will be provisioned through the cloud provider API. Templates can be created on the UI for Mesos and they can be linked to a hostgroup as well but these templates mean resource constraints that will be demanded through the Marathon API instead of resources that will created. 
Example:

- An AWS template with an instance type of `m4.large` and 4 pieces of 50 GB attached magnetic volumes will create a VM with these specs when Cloudbreak is building the cluster infrastructure.
- A Mesos template with 2 CPU cores and 4 GB memory means that Cloudbreak will request the Marathon API to schedule the Ambari container on a node where these resources can be satisfied

####4. Cloudbreak doesn't start a gateway instance.

On the cloud providers there is a gateway VM that's deployed for every new cluster by Cloudbreak. It runs a few containers like Ambari server but most importantly runs an Nginx server. Every communication between a Cloudbreak deployment and a cluster deployed by Cloudbreak goes through this Nginx instance. This is done on a 2-way TLS channel where the Nginx server is responsible for the TLS termination. Communication inside the cluster, like between Ambari server and agents is not encrypted but every communication from outside is secure. It enables Cloudbreak to be deployed outside of the private network of the cluster. The Mesos integration doesn't have a solution like this, so every communication between Cloudbreak and the cluster goes through an unencrypted channel. This is one of the reasons that in this case Cloudbreak should be deployed inside the same private network (or in the same Mesos cluster) where the clusters will be deployed.

## Technical Preview Restrictions

####1. No out-of-the-box dns solution like Consul.

In case of Mesos Cloudbreak does not provide a custom DNS solution like on other cloud providers, where Consul is used to provide addresses for every node and some services like Ambari server. In the Mesos tech preview containers are deployed with `net=host`, and Mesos nodes must be set up manually in a way to be able to resolve each other's hostnames to IP addresses and vice versa with reserve DNS. This is a requirement of Hadoop and it is usually accomplished by setting up the `/etc/hosts` file on each node in the cluster, but it can also be provided by some DNS servers like Amazon's default DNS server in a virtual network.
Example:

- there are 5 nodes in the Mesos cluster: `node1, node2, node3, node4 and node5` with IP addresses of `10.0.0.1 to 10.0.0.5` respectively.
- the `/etc/hosts` file on `node1` should contain these entries:

```
	10.0.0.2 node2
	10.0.0.3 node3
	10.0.0.4 node4
	10.0.0.5 node5
```

####2. Cloudbreak must be able to resolve the addresses of the Mesos slaves.

Cloudbreak must be able to communicate with the Ambari server that's deployed in the Mesos cluster to make the API requests needed for example to create a cluster. After Cloudbreak instructs Marathon to deploy the Ambari server container somewhere in the Mesos cluster it asks the address of the node where it was deployed and will try to communicate with the Ambari server through the address that was returned by Marathon. Take for example a Mesos cluster with 5 registered nodes: `node1, node2, node3, node4, node5`:

- Cloudbreak makes a `POST` request to the Marathon API to deploy the Ambari server container somewhere with enough resources.
- The Ambari server container is started on `node4`. The node address is returned to Cloudbreak.
- Cloudbreak tries to access `node4:8080` to check if Ambari is running.

Because of the lack of a gateway node, communication is unencrypted between Cloudbreak and the clusters, so it is suggested that Cloudbreak should be deployed in the same private network. In that case the above scenario is probably not a problem.
If Cloudbreak is not in the same network this can be solved by adding the addresses with a reachable IP in the `/etc/hosts` file of the machine where Cloudbreak is deployed.

####3. Storage management needs to be improved

This is one of the two biggest limitations of the current Mesos integration. There is no specific volume management in the current integration, which means that data is stored inside the Docker containers. This solution has a lot of problems that will be solved only in later releases:

- Data will only be stored on those volumes where Docker is installed (probably the root volume), attached volumes are not used
- After the container is destroyed the data is destroyed as well
- No data locality

####4. IP-per-task is not supported yet

The other big limitation of the current integration is the lack of IP-per-task support. Currently containers are deployed with `net=host` which means that only one container can be deployed per Mesos host because of possible port collisions, and that is the case even with multiple clusters.
IP-per-task means that every task of an app (all the containers) deployed through Marathon will get their own network interface and an IP address.
[This feature](https://mesosphere.github.io/marathon/docs/ip-per-task.html) is already available in Mesos/Marathon but does not work in combination with Docker containers.

####5. Recipes are not supported

Recipes are script extensions to an HDP cluster installation supported by Cloudbreak, but it is not supported with the Mesos integration because of the lack of a Consul deployment as this feature is heavily dependent on Consul's HTTP API.
