# Platforms

> This feature is currently `TECHNICAL PREVIEW`.

With this feature you can define platform tag that can be attached to Credentials, Networks and Templates. This way you 
can bundle together different configurations.

## Data locality and topologies

The [OpenStack documentation](http://docs.openstack.org/developer/sahara/icehouse/userdoc/features
.html#data-locality) about data locality:

>**IMPORTANT** It is extremely important **for data processing to do locally (on the same rack, OpenStack compute
node or even VM) as much work as possible**.

>Hadoop supports data-locality feature and can schedule jobs to task tracker nodes
that are local for input stream. In this case task tracker could communicate directly with local data node.

### OpenStack Topology Mapping

Topology mapping can be attached to the Platform definition, that associates the hypervisors with racks. 
You can set the mapping on the Cloudbreak Web UI by defining this line by line or uploading in a file.

The `mapping file` should have the following format:

    hypervisor1 /rack1
    hypervisor2 /rack2
    hypervisor3 /rack2

Based on this mapping the Cloudbreak application could ensure that the rack information of the started VMs will be
passed to Hadoop services via Ambari.

# Platform configuration via Browser

## Manage Platform configurations

>You can log into the Cloudbreak application at http://PUBLIC_IP:3000. You can find the provider specific
documentations here:
>
* [AWS](aws.md)
* [Azure](azure.md)
* [GCP](gcp.md)
* [OpenStack](openstack.md)

Platforms can be configured on the **manage platforms** panel on the Cloudbreak Dashboard.

To create a new platform configuration follow these steps:

  1. Select `OpenStack` from cloud provider tabs
  2. Fill out the new configuration `Name`
  3. Fill out the `Topology Mapping` section based on the above examples
     - Add mapping line by line

![](/images/platform-create.png)
<sub>*Full size [here](/images/platform-create.png).*</sub>

Explanation of the parameters:

- `Name` the name of the new configuration
    - Starts with a lowercase alphabetic
    - Can contain lowercase alphanumeric and hyphens only
    - Number of characters should be between 5 and 100
- `Topology Mapping`:
    - `Hypervisor` you can provide your hypervisor name
    - `Rack` you can provide the rack name for hypervisor

Optional parameters and theirs explanation:

- `Description` a maximum 1000 character long description for the new configuration
- `Upload Mapping File` mapping definition can be uploaded in a file
    - further details in the [Openstack Topology Mapping section](#openstack-topology-mapping)
- `Topology Mapping`:
    - `Hypervisor` you can provide your hypervisor name
    - `Rack` you can provide the rack name for hypervisor

>**NOTE** Platform name is the only one required parameter.

## Enable Platform configuration

Your Cloudbreak platform configuration can be applied on the following panels:

- `create network`
- `create credential`
- `create template`

To create a new network with a previously created configuration for instance; follow these steps on the **create
network** panel:

  1. Select `OpenStack` from cloud provider tabs
  2. Fill out the new network `Name`
  3. Fill out your network `Subnet (CIDR)`
  4. Fill out your `Public Network ID`
  5. Select your previously created platform from `Select Platform`

![](/images/platform-select_v2.png)
<sub>*Full size [here](/images/platform-select_v2.png).*</sub>

>**IMOPRTANT** If platform has assigned to the selected credential, then only the associated networks and templates can
 be selected during cluster creation.

# Platform configuration via CLI

## Manage Platform configurations

>Start the shell with `cbd util cloudbreak-shell` on a console. This will launch the Cloudbreak shell inside a Docker
 container and you are ready to start using it. You can find more details at the [Cloudbreak Shell](shell.md) page.

You can find two examples here
for `AWS`:
```
# Creating a Platform
platform create --AWS --name platform-name --description 'description of the platform'
```
or for `OPENSTACK`:
```
# Creating OpenStack Platform with topology mapping
platform create --OPENSTACK --name platform-name --description 'openstack platform' --file file_path
platform create --OPENSTACK --name platform-name --description 'openstack platform' --url url_to_file
```

## Enable Platform configuration

Your Cloudbreak platform configuration can be applied for the following shell commands as option to set a platform
for the resource:

- `network create`
- `credential create`
- `template create`

You can find an example shell command to create a new network with a connected platform:
```
network create --AWS --name aws-network --subnet 10.10.10.0/24 --description 'example network' --platformId 26
```

>**IMOPRTANT** If platform has assigned to the selected credential, then only the associated networks and templates can
 be selected during cluster creation.
