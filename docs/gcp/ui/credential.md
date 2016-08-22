## Setting up GCP Credentials

Cloudbreak works by connecting your GCP account through so called *Credentials*, and then uses these credentials to 
create resources on your behalf. The credentials can be configured on the **manage credentials** panel on the 
Cloudbreak Dashboard.

To create a new GCP credential follow these steps:

  1. Fill out the new credential `Name`
    - Only alphanumeric and lowercase characters (min 5, max 100 characters) can be applied
  2. Copy your GCP project ID to the `Project Id` field
  3. Copy your GCP Service Account email address to the `Service Account Email Address` field
  4. Upload your GCP Service Account private key (generated `p12 Key`) to the `Service Account Private (p12) Key` field
  5. Copy your SSH public key to the `SSH public key` field
    - The SSH public key must be in OpenSSH format and it's private keypair can be used later to [SSH onto every instance](operations.md#ssh-to-the-hosts) of every cluster you'll create with this credential.
    - The **SSH username** for the GCP instances is **cloudbreak**.

>Any other parameter is optional here.

>`Public in account` means that all the users belonging to your account will be able to use this credential to create 
clusters, but cannot delete it.

![](/gcp/images/gcp-credential.png)
<sub>*Full size [here](/gcp/images/gcp-credential.png).*</sub>
