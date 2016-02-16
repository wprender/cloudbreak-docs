

## Account management on UI

On the Cloudbreak UI (Uluwatu) there are opportunity to review the user's account settings and manage some properties.

### Account Details page

You can reach the `account details` page by clicking on the `account` header menu.

#### Security scopes

Next to the `Scope` field you can check the security scopes the user has. **The list of scopes the user has are not modifiable in this version of UI.**

Recently Cloudbreak has distinct security scope for the following resources:

 - Blueprints
 - Recipes
 - Templates
 - Credentials
 - Stacks
 - Networks
 - Security Groups

In the future the list of security scopes could be extended with new resources.

#### Cloud platforms

Under the `Cloud platforms` field you can see the supported cloud platforms and whether they are displayed on the UI.

Admin users can even change the displayed Cloud platforms.
For example if only the Aws cloud platform is set to be displayed then under the `dashboard` header menu the `manage networks`, `manage resourcers`, `manage credentials`, `manage platforms` and under the `select a credential` header menu you can see only Aws related resourcers.

Supported Cloud platforms:

 - Aws
 - Azure rm
 - GCP
 - Openstack

