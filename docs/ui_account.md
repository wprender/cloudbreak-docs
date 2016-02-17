

# Account management on UI

On the Cloudbreak UI (Uluwatu) there are opportunity to review the user's entitlements and manage some settings.

## Account Details page

You can view the `account details` on the `account` page (by clicking on the related header menu).

### Security scopes

On the expanded `account details` you can check your **security scopes**.
> **Note:** Even the administrator users cannot modify the list of scopes.

Cloudbreak has distinct security scope for the following resources:

 - Blueprints
 - Recipes
 - Templates
 - Credentials
 - Stacks
 - Networks
 - Security Groups

> In the future the list of security scopes could be extended with new resources.

### Cloud platforms

`Cloud platforms` table lists the supported cloud platforms by Cloudbreak.

**Administrator users can set the used (what will be available) cloud platforms for the group.**

**For example:** If the AWS cloud platform is the selected, only the AWS networks, resources, credentials and 
platforms to be displayed and can be created for every users in the account (also for the managed users).

#### Supported Cloud platforms:

 - AWS
 - Azure RM
 - GCP
 - OpenStack
