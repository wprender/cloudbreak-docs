## Cluster termination

You can terminate running or stopped clusters with the `terminate` button in the cluster details.

>**IMPORTANT** Always use Cloudbreak to terminate the cluster. If that fails for some reason, try to delete the 
OpenStack instances first. Instances are started in an Auto Scaling Group so they may be restarted if you terminate an 
instance manually!

Sometimes Cloudbreak cannot synchronize it's state with the cluster state at the cloud provider and the cluster can't
 be terminated. In this case the `Forced termination` option can help to terminate the cluster at the Cloudbreak 
 side. **If it has happened:**

1. You should check the related resources at the OpenStack
2. If it is needed you need to manually remove resources from there

![](/images/os-forceterminate.png)
<sub>*Full size [here](/images/os-forceterminate.png).*</sub>