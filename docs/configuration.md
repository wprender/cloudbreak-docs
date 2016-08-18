# Advanced Configuration

Cloudbreak Deployer configuration is based on environment variables. Cloudbreak Deployer always opens a new bash subprocess **without inheriting environment variables**. Only the following environment variables _are_ inherited:

- `HOME`
- `DEBUG`
- `TRACE`
- `CBD_DEFAULT_PROFILE`
- all `DOCKER_XXX`

To set environment variables relevant for Cloudbreak Deployer, add them to a file called `Profile`.

To see all available environment variables with their default values, run:

```
cbd env show
```

The `Profile` file is **sourced**, so you can use the usual syntax to set configuration values:

```
export MY_VAR=some_value
export OTHER_VAR=another_value
```


## Environment Specific Profiles

Let’s say that you want to use a different version of Cloudbreak for **prod** and **qa** profile. Since the `Profile` file is sourced, you will have to create two environment specific configurations that can be sourced:  
- `Profile.prod`  
- `Profile.qa`

For example, to create and use a **prod** profile, you need to:

1. Create a file called `Profile.prod`
2. Write the environment-specific `export DOCKER_TAG_CLOUDBREAK=0.3.99` into `Profile.prod` to specify Docker image.
3. Set the environment variable: `CBD_DEFAULT_PROFILE=prod`

To use the `prod` specific profile once, set:
```
CBD_DEFAULT_PROFILE=prod cbd some_commands
```

To permanently use the  `prod` profile, set `export CBD_DEFAULT_PROFILE=prod` in your `.bash_profile`.

## Available Configurations

### SMTP

If you want to change SMTP parameters, add them your `Profile`.  

The default values of the SMTP parameters are:
```
export CLOUDBREAK_SMTP_SENDER_USERNAME=
export CLOUDBREAK_SMTP_SENDER_PASSWORD=
export CLOUDBREAK_SMTP_SENDER_HOST=
export CLOUDBREAK_SMTP_SENDER_PORT=25
export CLOUDBREAK_SMTP_SENDER_FROM=
export CLOUDBREAK_SMTP_AUTH=true
export CLOUDBREAK_SMTP_STARTTLS_ENABLE=true
export CLOUDBREAK_SMTP_TYPE=smtp
```

#### SMTPS 

If your SMTP server uses SMTPS, you must set the protocol in your `Profile` to `smtps`:
```
export CLOUDBREAK_SMTP_TYPE=smtps
```
#### Certificates 

If the certificate used by the SMTP server is self-signed or the Java's default trust store doesn't contain it, you can add it to the trust store by copying it to `certs/trusted` inside the Cloudbreak Deployer directory, and start (or restart) the Cloudbreak container (with `cbd start`). On startup, the Cloudbreak container  automatically imports the certificates in that directory to its trust store.

###Access from Custom Domains

Cloudbreak Deployer supports multitenancy and uses UAA as an identity provider. In UAA, multitenancy is managed through identity zones. An identity zone is accessed through a unique subdomain. For example, if the standard UAA responds to [https://uaa.10.244.0.34.xip.io](https://uaa.10.244.0.34.xip.io), a zone on this UAA can be accessed through a unique subdomain [https://testzone1.uaa.10.244.0.34.xip.io](https://testzone1.uaa.10.244.0.34.xip.io). 

If you want to use a custom domain for your identity or deployment, add the `UAA_ZONE_DOMAIN` line to your `Profile`:
```
export UAA_ZONE_DOMAIN=my-subdomain.example.com
```

For example, in our hosted deployment, the `identity.sequenceiq.com` domain refers to our identity server; therefore, the `UAA_ZONE_DOMAIN` variable has to be set to that domain. This variable is necessary for UAA to identify which zone provider should handle the requests that arrive to that domain.


### Consul

Cloudbreak uses [Consul](http://consul.io) for DNS resolution. All Cloudbreak-related services are registered as **someservice.service.consul**. 

Consul’s built-in DNS server is able to fall back on another DNS server.
This option is called `-recursor`. Clodbreak Deployer first tries to discover the DNS settings of the host by looking for **nameserver** entry in the `/etc/resolv.conf` file. If it finds one, consul will use it as a recursor. Otherwise, it will use **8.8.8.8** .

For a full list of available consul config options, see Consul [documentation](https://consul.io/docs/agent/options.html).

To pass any additional Consul configuration, define a `DOCKER_CONSUL_OPTIONS` in the `Profile` file.

### SSH Fingerprint Verification

Cloudbreak is able to verify the SSH fingerprints of the provisioned virtual machines. We disable this feature by default for AWS and GCP, because we have experienced issues caused by the fact that Ccoud providers do not always print the SSH fingerprint into the provisioned machines console output. The fingerprint validation feature can be turned on by configuring the `CB_AWS_HOSTKEY_VERIFY` and/or the `CB_GCP_HOSTKEY_VERIFY` variables in your `Profile`. For example:
```
export CB_AWS_HOSTKEY_VERIFY=true
export CB_GCP_HOSTKEY_VERIFY=true
```

## Provider Specific Configurations

### Azure Resource Manager Command

- **cbd azure configure-arm**
- **cbd azure deploy-dash**

For more information, see Azure [documentation](/azure/#azure-application-setup-with-cloudbreak-deployer).

