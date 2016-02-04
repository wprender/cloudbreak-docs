
# Platforms/Topologies

> This feature is currently `TECHNICAL PREVIEW`.

## Define Platform

With this feature you can define names/tags that can be attached to Credentials, Networks and Templates. This way you can bundle together different configurations.

## Data locality and topologies

The [Openstack documentation](http://docs.openstack.org/developer/sahara/icehouse/userdoc/features.html#data-locality) about data locality:
> It is extremely important for data processing to do locally (on the same rack, openstack compute node or even VM) as much work as possible. Hadoop supports data-locality feature and can schedule jobs to tasktracker nodes that are local for input stream. In this case tasktracker could communicate directly with local data node.

In case of Openstack you can attach to the Platform definition a topology mapping that associates the hypervisors with racks. You can set the mapping on the Cloudbreak web (Uluwatu) by defining the mapping line by line or uploading a mapping file.

The mapping file should have the following format:

    hypervisor1 /rack1
    hypervisor2 /rack2
    hypervisor3 /rack2

Based on this mapping the Cloudbreak application could ensure that the rack information of the started VMs will be passed to Hadoop services via Ambari.

## Managing Platforms

### Cloudbreak UI

There's only one required parameter on the Platform creation form - the name of the Platform.
![](/images/platform-simple.png)

In case of Openstack there's possible to set optionally the Topolgy mapping.
![](/images/platform-form-filled.png)

### Cloudbreak Shell commands

```
# Creating a Platform
topology create --AWS --name platform-name --description 'description of the platform'

# Creating Openstack Platform with topology mapping
topology create --OPENSTACK --name platform-name --description 'openstack platform' --file file_path
topology create --OPENSTACK --name platform-name --description 'openstack platform' --url url_to_file
```

## Credentials, Templates, Networks

Credential, Template and Network creation forms and shell creation commands all have an option to set a Platform for the resource.

```
# Example shell command to create Network resource with a connected Platform
network create --AWS --name aws-network --subnet 10.10.10.0/24 --description 'example network' --topologyId 26
```

Example network resource creation an the UI with the option of selecting a Platform:
![](/images/platform-select.png)

## Cluster creation on UI

On the UI if a Credential with Platform was selected for cluster creation then during the configuration only the Networks and Templates that belong to the same Platform or no Platform could be selected.

