#Recipes

Although Cloudbreak lets you provision Hadoop clusters in the cloud from Ambari blueprints, Cloudbreak built-in provisioning doesn't contain all possible use cases. For that reason, we introduced recipes.

A **recipe** is a script extension to a cluster that runs on all nodes before or after the Ambari cluster installation. For example, you can use a recipe to put a JAR file on the Hadoop classpath. Recipes are uploaded and stored in Cloudbreak through the web UI or shell.

The easiest way to create a custom recipe is to:

  * Create your own pre and/or post scripts
  * Upload them using the web UI or shell 

##Adding Recipes

To add recipe via the web UI, in the **manage recipes** section, choose **create new recipe**. Next, select either SCRIPT or FILE type plugin and fill in required fields.

To add recipe via shell, use the following command:

```
recipe store --name [recipe-name] --preInstallScriptFile /path/of/the/pre-install-script --postInstallScriptFile /path/of/the/post-install-script
```

This command has optional parameters:

`--description` "string" description of the recipe

`--timeout` "integer" timeout of the script execution

`--publicInAccount` "flag" flags if the recipe is public in the account

## Sample Recipe for Yum Proxy Setting

We've created a sample recipe that can be used to set proxy for yum:

```
#!/bin/bash
cat >> /etc/yum.conf <<ENDOF
proxy=http://10.0.0.133:3128
ENDOF
```

![](/images/create-recipe.png)

You can add this recipe to hostgroups:

![](/images/select-recipe.png)

