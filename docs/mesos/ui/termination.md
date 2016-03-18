## Cluster termination

You can terminate running or stopped clusters with the `terminate` button in the cluster details.

>**IMPORTANT** Always use Cloudbreak to terminate the cluster instead of deleting the containers through the Marathon API. Deleting them first would cause inconsistencies between Cloudbreak's database and the real state and that could lead to errors.