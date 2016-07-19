

# Manage Your Account Using Cloudbreak UI

You can use the Cloudbreak UI (Uluwatu) to view and manage your settings.

## Account Details 

Go to the `account` page and view your `account details`.

### Security Scopes

Expand the `account details` page to check your **security scopes**.
> **Note: ** Even administrator users cannot modify the list of scopes.

Cloudbreak has distinct security scopes for the following resources:

 - Blueprints
 - Templates
 - Credentials
 - Stacks
 - Networks
 - Security Groups

> **Note: ** In the future, the list of security scopes may be extended to include new resources.

### Cloud Platforms

`Cloud platforms` table lists cloud platforms supported by Cloudbreak.

**Only administrator users can set the cloud platforms used by the group.** For example, if the administrator selects AWS cloud platform, only AWS networks, resources, and credentials will be displayed and can be created for users in the account (including managed users).

#### Supported Cloud Platforms:

 - AWS
 - Azure RM
 - GCP
 - OpenStack
