## Cluster deployment

After all the cluster resources are configured you can deploy a new HDP cluster.

Here is a **basic flow for cluster creation on Cloudbreak's Web UI**:

 - Start by selecting a previously created Mesos credential in the header.

 - Click on `create cluster`

`Configure Cluster` tab

 - Fill out the new cluster `name`
    - Cluster name must start with a lowercase alphabetic character then you can apply lowercase alphanumeric and 
   hyphens only (min 5, max 40 characters)
 - Click on the `Choose Blueprint` button
>If `Public in account` is checked all the users belonging to your account will be able to see the created cluster on
 the UI, but cannot delete or modify it.

`Choose Blueprint` tab

 - Select one of the blueprints
 - After you've selected a `Blueprint`, you should be able to configure:
    - the resource constraints
    - the number of nodes for all of the host groups in the blueprint
 - Click on the `Review and Launch` button

`Review and Launch` tab

 - After the `create and start cluster` button was clicked Cloudbreak will start to orchestrate the Ambari containers through your Marathon API.

You can check the progress on the Cloudbreak Web UI if you open the new cluster's `Event History`. It is available if you click on the cluster's name.

**Advanced options**

There are some advanced features when deploying a new cluster, these are the following:

`Validate blueprint` This is selected by default. Cloudbreak validates the Ambari blueprint in this case.

`Config recommendation strategy` Strategy for configuration recommendations how will be applied. Recommended 
configurations gathered by the response of the stack advisor. 

* `NEVER_APPLY`               Configuration recommendations are ignored with this option.
* `ONLY_STACK_DEFAULTS_APPLY` Applies only on the default configurations for all included services.
* `ALWAYS_APPLY`              Applies on all configuration properties.