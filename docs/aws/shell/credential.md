## Setting up AWS credential

Cloudbreak works by connecting your AWS account through so called Credentials, and then uses these credentials to 
create resources on your behalf. Credentials can be configured with the following command for example:

```
credential create --AWS --name my-aws-credential --description "sample description" --roleArn 
arn:aws:iam::***********:role/userrole --sshKeyString "ssh-rsa AAAAB****etc"
```

>**NOTE** that Cloudbreak **does not set your cloud user details** - we work around the concept of [IAM](http://aws.amazon.com/iam/) - **on Amazon (or other cloud providers)**. You should have already a valid IAM role. You can 
find further details [here](aws.md#provisioning-prerequisites).

Alternatives to provide `SSH Key`:

- you can upload your public key from an url: `—sshKeyUrl` 
- or you can add the path of your public key: `—sshKeyPath`

You can check whether the credential was created successfully

```
credential list
```

You can switch between your existing credentials

```
credential select --name my-aws-credential
```
