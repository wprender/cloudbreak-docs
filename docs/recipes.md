#Recipes

With the help of Cloudbreak it is very easy to provision Hadoop clusters in the cloud from an Apache Ambari blueprint. Cloudbreak built in provisioning doesn't contain every use case, so we are introducing the concept of recipes.

Recipes are basically script extensions to a cluster that run on all nodes before or after the Ambari cluster installation. With recipes it's quite easy for example to put a JAR file on the Hadoop classpath or run some custom scripts.

##Stored recipes

Recipes are uploaded and stored in Cloudbreak via web interface or shell.

The easiest way to create a custom recipe:

  * create your own pre and/or post scripts
  * upload them on shell or web interface

###Add recipe

On the web interface under **manage recipes** section you should **create new recipe**. Please choose between SCRIPT or FILE type plugin, and fill required fields.

To add recipe via shell use the following command:

```
recipe store --name [recipe-name] --preInstallScriptFile /path/of/the/pre-install-script --postInstallScriptFile /path/of/the/post-install-script
```

This command has optional parameters:

`--description` "string" description of the recipe

`--timeout` "integer" timeout of the script execution

`--publicInAccount` "flag" flags if the recipe is public in the account

## Sample recipe for Yum proxy setting

```
#!/bin/bash
cat >> /etc/yum.conf <<ENDOF
proxy=http://10.0.0.133:3128
ENDOF
```
We've created a sample recipe that can be used to set proxy for yum.

![](/images/create-recipe.png)

You can add this recipe to hostgroups:

![](/images/select-recipe.png)

