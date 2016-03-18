## Setting up Marathon credentials

Cloudbreak works by connecting your Marathon API through so called *Credentials*, and then uses the API to schedule containers on your Mesos cluster. The credentials can be configured on the **manage credentials** panel on the Cloudbreak Dashboard.

To create a new Marathon credential follow these steps:

  1. Fill out the new credential `Name`
    - Only alphanumeric and lowercase characters (min 5, max 100 characters) can be applied
  2. Add an optional description
  2. Specify the endpoint of your Marathon API in this format: `http://<marathon-address>:<port>`. Example: `http://172.16.252.31:8080`.
  
>`Public in account` means that all the users belonging to your account will be able to use this credential to create 
clusters, but cannot delete it.

Authentication and HTTPS to a Marathon API is not yet supported by Cloudbreak.