## Setting up GCP credential

Cloudbreak works by connecting your GCP account through so called Credentials, and then uses these credentials to 
create resources on your behalf. Credentials can be configured with the following command for example:
```
credential create --GCP --description "sample description" --name my-gcp-credential --projectId <your gcp projectid> 
--serviceAccountId <your GCP service account mail address> --serviceAccountPrivateKeyPath /files/mykey.p12 
--sshKeyString "ssh-rsa AAAAB3***etc."
```
>**NOTE** that Cloudbreak **does not set your cloud user details** - we work around the concept of GCP Service 
Account Credentials. You should have already a valid GCP service account. You can find further details [here](gcp.md#provisioning-prerequisites).

Alternatives to provide `SSH Key`:

- you can upload your public key from an url: `—sshKeyUrl` 
- or you can add the path of your public key: `—sshKeyPath`

You can check whether the credential was created successfully
```
credential list
```
You can switch between your existing credentials
```
credential select --name my-gcp-credential
```
