

# Manage Your Account Using the Cloudbreak Web UI

You can use the Cloudbreak web UI to view and manage your settings.

## Account Details 

Click on `account` in the header menu to go the `account` page and expand the `account details` tab.

### Security Scopes

Expand the `account details` tab to check your security scopes.
Even administrator users cannot modify the list of scopes.

Cloudbreak has distinct security scopes for the following resources:

 - Blueprints
 - Templates
 - Credentials
 - Stacks
 - Networks
 - Security Groups

> **Note: ** In the future, the list of security scopes may be extended to include new resources.

### Cloud Platforms

The `Cloud platforms` table lists cloud platforms supported by Cloudbreak.

Only administrator users can set the cloud platforms used by the group. For example, if the administrator selects AWS cloud platform, only AWS networks, resources, and credentials will be displayed and can be created for users in the account (including managed users).

The following cloud platforms are supported:

 - AWS
 - Azure RM
 - GCP
 - OpenStack
