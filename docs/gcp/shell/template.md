## Infrastructure templates

After your GCP account is linked to Cloudbreak you can start creating resource templates that describe your clusters'
infrastructure:

- security groups
- networks
- templates

When you create one of the above resource, **Cloudbreak does not make any requests to GCP. Resources are only created
 on GCP after the `cluster create` has applied.** These templates are saved to Cloudbreak's database and can be
 reused with multiple clusters to describe the infrastructure.

**Templates**

Templates describe the **instances of your cluster** - the instance type and the attached volumes. A typical setup is
 to combine multiple templates in a cluster for the different types of nodes. For example you may want to attach multiple
 large disks to the datanodes or have memory optimized instances for Spark nodes.

A template can be used repeatedly to create identical copies of the same stack (or to use as a foundation to start a
new stack). Templates can be configured with the following command for example:
```
template create --GCP --name my-gcp-template --instanceType n1-standard-2 --volumeCount 2 --volumeSize 100
```
Other available options here:

`--volumeType` The default is `pd-standard` (HDD), other allowed value is `pd-ssd`
(SSD).

`--preemptible` is true, the template will be [preemptible](https://cloud.google.com/compute/docs/instances/preemptible)

`--publicInAccount` is true, all the users belonging to your account will be able to use this template
to create clusters, but cannot delete it.

You can check whether the template was created successfully
```
template list
```
