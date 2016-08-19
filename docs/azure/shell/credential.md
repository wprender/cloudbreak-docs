## Setting up Azure Credential

Cloudbreak works by connecting your Azure account through so called Credentials, and then uses these credentials to 
create resources on your behalf. Credentials can be configured with the following command for example:
```
credential create --AZURE --name my-azure-credential --description "sample credential" --subscriptionId 
your-azure-subscription-id --tenantId your-azure-application-tenant-id --appId 
your-azure-application-id --password YourApplicationPassword --sshKeyString "ssh-rsa AAAAB3***etc."
```

> Cloudbreak is supporting simple rsa public key instead of X509 certificate file after 1.0.4 version

>**NOTE:** Cloudbreak **does not set your cloud user details** - we work around the concept of Access Control 
Service (ACS). You should have already a valid Azure Subscription and Application. You can find further details [here](azure.md#provisioning-prerequisites).

Alternatives to provide `SSH Key`:

- you can upload your public key from an url: `—sshKeyUrl` 
- or you can add the path of your public key: `—sshKeyPath`

You can check whether the credential was created successfully
```
credential list
```
You can switch between your existing credentials
```
credential select --name my-azure-credential
```
