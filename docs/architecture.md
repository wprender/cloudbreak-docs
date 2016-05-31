# Architecture

##Cloudbreak Deployer Architecture

- **uaa**: OAuth Identity Server
- **cloudbreak**: the Cloudbreak app
- **periscope**: the Periscope app
- **uluwatu**: Cloudbreak UI
- **sultans**: user management

### System Level Containers

- **consul**: Service Registry
- **registrator**: automatically registers/unregisters containers with consul

##Cloudbreak Application Architecture

Cloudbreak is built on the foundation of cloud providers APIs and Apache Ambari.

###Apache Ambari

The Apache Ambari project is aimed at making Hadoop management simpler by developing software for provisioning, managing, and monitoring Apache Hadoop clusters. Ambari provides an intuitive, easy-to-use Hadoop management web UI backed by its RESTful APIs.

![](https://raw.githubusercontent.com/sequenceiq/cloudbreak/master/docs/images/ambari-overview.png)

####System Administrators
Ambari enables to integrate Hadoop provisioning, management and monitoring capabilities into applications with the Ambari REST APIs.

  1. **Provision a Hadoop Cluster**:
     * Ambari provides a step-by-step wizard for installing Hadoop services across any number of hosts.
     * Ambari handles configuration of Hadoop services for the cluster.
  2. **Manage a Hadoop Cluster**:
     * Ambari provides central management for starting, stopping, and reconfiguring Hadoop services across the entire.
   cluster.
  3. **Monitor a Hadoop Cluster**:
     * Ambari provides a dashboard for monitoring health and status of the Hadoop cluster.
     * Ambari allows to choose between predefined alerts or add your custom ones.

####Ambari Blueprint
Ambari blueprints are a declarative definition of a cluster. With a blueprint, you can specify stack, component
 layout and configurations to materialise a Hadoop cluster instance (via a REST API) without having to use the Ambari
  Cluster Install Wizard.

![](https://raw.githubusercontent.com/sequenceiq/cloudbreak/master/docs/images/ambari-create-cluster.png)

####Salt
Salt is a software to manage complex systems at scale. Salt can be used for data-driven orchestration, remote execution for any infrastructure, configuration management for any app stack, and much more.
