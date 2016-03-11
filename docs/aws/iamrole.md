## IAM role setup

Cloudbreak works by connecting your AWS account through so called *Credentials*, and then uses these credentials to 
create resources on your behalf.

>**IMPORTANT** Cloudbreak deployment uses two different AWS accounts for two different purposes:

- The account belonging to the *Cloudbreak webapp* itself, acts as a *third party*, that creates resources on the 
account of the *end user*. This account is configured at server-deployment time.
- The account belonging to the *end user* who uses the UI or the Shell to create clusters. This account is configured
 when setting up credentials.

These accounts are usually *the same* when the end user is the same who deployed the Cloudbreak server, but it allows
 Cloudbreak to act as a SaaS project as well if needed.

Credentials use [IAM Roles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) to give access to the 
third party to act on behalf of the end user without giving full access to your resources.
This IAM Role will be *assumed* later by an IAM user.

**AWS IAM Policy that grants permission to assume a role**

**You cannot assume a role with root account**, so you need to **create an IAM user** with an attached [*Inline* 
policy](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html) and **then set the 
Access key and Secret Access key** in the 
`Profile` file (check [this description](aws.md#aws-specific-configuration) out).

The `sts-assume-role` IAM user [policy](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_control-access_enable-create.html) must be configured to have 
permission to assume roles on all resources. Here it is the policy to configure the `sts:AssumeRole` for all 
`Resource`:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1400068149000",
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```

To connect your (*end user*) AWS account with a credential in Cloudbreak you'll have to create an IAM role on your 
AWS account that is configured to allow the third-party account to access and create resources on your behalf.
The easiest way to do this is with `cbd` commands (but it can also be done manually from the [AWS Console](https://console.aws.amazon.com)):

```
cbd aws generate-role  - Generates an AWS IAM role for Cloudbreak provisioning on AWS
cbd aws show-role      - Show assumers and policies for an AWS role
cbd aws delete-role    - Deletes an AWS IAM role, removes all inline policies
```

The `generate-role` command creates a role that is assumable by the Cloudbreak Deployer AWS account and has a broad policy setup.
This command creates a role with the name `cbreak-deployer` by default. If you'd like to create role with a different
 name or multiple roles, you need to add this line to your `Profile`:

```
export AWS_ROLE_NAME=my-cloudbreak-role
```
You can check the generated role on your AWS console, under IAM roles:
![](../images/aws-iam-role_v2.png)
<sub>*Full size [here](../images/aws-iam-role_v2.png).*</sub>
