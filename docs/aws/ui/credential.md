## Setting up AWS credentials

Cloudbreak works by connecting your AWS account through so called *Credentials*, and then uses these credentials to 
create resources on your behalf. The credentials can be configured on the **manage credentials** panel on the 
Cloudbreak Dashboard.

To create a new AWS credential follow these steps:

  1. Select the credential type. For instance, select the `Role Based`
  2. Fill out the new credential `Name`
    - Only alphanumeric and lowercase characters (min 5, max 100 characters) can be applied
  3. Copy your AWS IAM role's Amazon Resource Name (ARN) to the `IAM Role ARN` field
  4. Copy your SSH public key to the `SSH public key` field
    - The SSH public key must be in OpenSSH format and it's private keypair can be used later to [SSH onto every 
    instance](operations.md#ssh-to-the-hosts) of every cluster you'll create with this credential.
    - The **SSH username** for the EC2 instances is **ec2-user**.

>Any other parameter is optional here.

>`Public in account` means that all the users belonging to your account will be able to use this credential to create 
clusters, but cannot delete it.

![](/aws/images/aws-credential_v3.png)
<sub>*Full size [here](/aws/images/aws-credential_v3.png).*</sub>
