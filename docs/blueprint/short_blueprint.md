## Defining cluster services

**Blueprints**

Blueprints are your declarative definition of a Hadoop cluster. These are the same blueprints that are [used by Ambari](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints).

You can use the 3 default blueprints pre-defined in Cloudbreak or you can create your own ones.
Blueprints can be added from file, URL (an [example blueprint](https://raw.githubusercontent
.com/sequenceiq/cloudbreak/master/integration-test/src/main/resources/blueprint/multi-node-hdfs-yarn.bp)) or the 
whole JSON can be written in the `JSON text` box.

The host groups in the JSON will be mapped to a set of instances when starting the cluster. Besides this the services and
 components will also be installed on the corresponding nodes. Blueprints can be modified later from the Ambari UI.
 
>**NOTE** Not necessary to define all the configuration in the blueprint. If a configuration is missing, Ambari will 
fill that with a default value.

If `Public in account` is checked all the users belonging to your account will be able to use this blueprint to 
create clusters, but cannot delete or modify it.

![](../images/ui-blueprints_v3.png)
<sub>*Full size [here](../images/ui-blueprints_v3.png).*</sub>

**A blueprint can be exported from a running Ambari cluster that can be reused in Cloudbreak with slight 
modifications.**
There is no automatic way to modify an exported blueprint and make it instantly usable in Cloudbreak, the 
modifications have to be done manually.
When the blueprint is exported some configurations are hardcoded for example domain names, memory configurations...etc. that won't be applicable to the Cloudbreak cluster.