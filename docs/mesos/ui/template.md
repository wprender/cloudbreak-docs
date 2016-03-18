## Resource constraints

After your Marathon API is linked to Cloudbreak you can start creating resource constraint templates that describe the resources requested through the Marathon API when starting an Ambari container.

When you create a resource constraint template, **Cloudbreak does not make any requests to Marathon. Resources are only requested after the `create cluster` button was pushed and Cloudbreak starts to orchestrate containers.** These templates are saved to Cloudbreak's database and can be reused with multiple clusters to describe the same resource constraints.

A typical setup is to combine multiple templates in a cluster for the different types of nodes. For example you may want to request more memory for Spark nodes.

The resource contraint templates can be configured on the **manage templates** panel on the Cloudbreak Dashboard under the Mesos tab. You can specify the memory, CPU and disk needed by the nodes in a hostgroup. If `Public in account` is checked all the users belonging to your account will be able to use this resource to create clusters, but cannot delete it.
