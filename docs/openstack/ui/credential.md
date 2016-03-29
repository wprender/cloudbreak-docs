## Setting up OpenStack credentials

Cloudbreak works by connecting your OpenStack account through so called *Credentials*, and then uses these credentials
 to create resources on your behalf. The credentials can be configured on the **manage credentials** panel on the 
Cloudbreak Dashboard.

To create a new OpenStack credential follow these steps:

  1. Select the [`Keystone Version`](http://docs.openstack.org/developer/keystone/http-api.html). For instance, select the `v2`
  2. Fill out the new credential `Name`
    - Only alphanumeric and lowercase characters (min 5, max 100 characters) can be applied
  3. Copy your OpenStack user name to the `User` field
  4. Copy your OpenStack user password to the `Password` field
  5. Copy your OpenStack tenant name to the `Tenant Name` field
  6. Copy your OpenStack identity service (Keystone) endpoint (e.g. http://PUBLIC_IP:5000/v2.0) to the `Endpoint` field
  7. Copy your SSH public key to the `SSH public key` field
    - The SSH public key must be in OpenSSH format and it's private keypair can be used later to [SSH onto every 
    instance](operations.md#ssh-to-the-hosts) of every cluster you'll create with this credential.
    - The **SSH username** for the OpenStack instances is **centos**.

>Any other parameter is optional here. You can read more about Keystone v3 [here](http://developer.openstack.org/api-ref-identity-v3.html).

>`API Facing` is the URL perspective in which the API is accessing data.

>`Public in account` means that all the users belonging to your account will be able to use this credential to create 
clusters, but cannot delete it.

![](/images/os-credential_v2.png)
<sub>*Full size [here](/images/os-credential_v2.png).*</sub>
