#### Upscale Cluster

If you need more instances to your infrastructure, you can **upscale your selected stack**:
```
stack node --ADD --instanceGroup host_group_slave_1 --adjustment 6
```
Other available option is `--withClusterUpScale` - this indicates also a cluster upscale after the stack upscale. You
 can upscale the related cluster separately if you want to do this:
```
cluster node --ADD --hostgroup host_group_slave_1 --adjustment 6
```
#### Downscale Cluster

You also can reduce the number of instances in your infrastructure. **After you selected your stack**:
```
cluster node --REMOVE  --hostgroup host_group_slave_1 --adjustment -2
```
Other available option is `--withStackDownScale` - this indicates also a stack downscale after the cluster downscale.
 You can downscale the related stack separately if you want to do this:
```
stack node --REMOVE  --instanceGroup host_group_slave_1 --adjustment -2
```
