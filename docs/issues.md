# Known issues

## Decommission

* [AMBARI-15294](https://issues.apache.org/jira/browse/AMBARI-15294) In case of downscaling if the selected host group contains an HBase RegionServer it's not guaranteed that all regions will be safely moved to another RegionServer which will remain as part of the cluster. If you choose to scale down such a host group Cloudbreak won't track the region movement process. It is recommended to put the RegionServers in a different host group in your blueprint than the ones you'll be scaling.