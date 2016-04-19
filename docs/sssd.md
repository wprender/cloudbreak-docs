# System Security Services Daemon

> This feature is currently `TECHNICAL PREVIEW`.

By default Cloudbreak installs Hadoop with a few default users. Most of the time, default users do not give great freedom, to manage permissions in the ecosystem.
Other big problem around the user management is that created users must be consistent on the whole cluster, otherwise operations will fail.

That's where *System Security Services Daemon* (SSSD) comes in picture. SSSD is a system daemon. Its primary function is to provide access to remote identity and authentication resources through a common framework that can provide caching and offline support to the system. Cloudbreak helps to install and configure SSSD, and sets up an SSH server on Ambari hosts, to allow log in with external users on the host's 2022 port.

```
ssh [external-user]@[ambari-host] -p 2022
```
# SSSD configurations via Browser

## Manage SSSD configurations

The SSSD can be configured on the **manage security configurations** panel on the Cloudbreak Dashboard.

To create a new SSSD configuration follow these steps:

  1. Fill out the new security configuration `Name`
  2. Select `Parameters` as `Configuration Type`
  3. Select `LDAP` as `Provider Type`
  4. Copy your LDAP URL to the `Provider URL` field
  5. Select `RFC2307` as `Database Shema Type`
  6. Copy your base search string to the `Search Base Of Users And Groups` field
  7. Select `Never` as `TLS Behavior Of The Connection`

![](/images/sssd-create.png)
<sub>*Full size [here](/images/sssd-create.png).*</sub>

Explanation of the parameters:

- `Name` the name of the new security configuration
    - Starts with a lowercase alphabetic
    - Can contain lowercase alphanumeric and hyphens only
    - Number of characters should be between 1 and 100
- `Configuration Type`:
    - `Parameters` you can provide your configuration parameters on the GUI
    - `File` you can upload your configuration file
    - `Text` you can copy-paste your configuration`
- `Provider Type`
    - `LDAP` Lightweight Directory Access Protocol
    - `Active Directory` Active Directory
    - `IPA` Identity, Policy and Audit suit
- `Provider URL` your LDAP or AD provider address
    - Can contain LDAP and AD protocols only
    - Number of characters should be between 10 and 255
- `Database Shema Type` The schema defines all the objects and attributes that the service uses to implementation,
store data.
    - `RFC2307`
    - `RFC2307BIS`
    - `IPA`
    - `Active Directory`
- `Search Base Of Users And Groups` your base search string for your Users and Groups
    - Number of characters should be between 10 and 255
- `TLS Behavior Of The Connection` applied Transport Layer Security

Optional parameters and theirs explanation:

- `Description` a maximum 1000 character long description for the new configuration
- `Active Directory Server(s)` IP address or Host name of the used Active Directory server
    - In case of more than one server, the list should be comma-separated
- `Kerberos Server(s)` IP address or Host names of the Kerberos server
    - In case of more than one server, the list should be comma-separated
- `Kerberos Realm` name of your Kerberos Realm
- `Public In Account` If it is checked, all the users belonging to your account will be able to use this security
configuration, but cannot delete it

## Enable SSSD configuration

Your Cloudbreak SSSD configuration can be applied on the **Create cluster** panel on the Cloudbreak Dashboard.

To create a new cluster with SSSD configuration follow these steps:

  1. Fill out the `Configure Cluster` tab with appropriate values
  2. Open the `Setup Network and Security` tab
     1. Select a `Network` and a `Security Group` that fit for your needs
     2. Check the `Use pre configured SSSD`
     3. `Select configuration` from your previously saved security configurations
  3. `Choose Blueprint`...etc.

![](/images/preconfigured-sssd.png)
<sub>*Full size [here](/images/preconfigured-sssd.png).*</sub>

## Embedded LDAP support

In Cloudbreak there is a built in but optional LDAP service. Your Cloudbreak SSSD configuration can be applied on the **Create cluster** panel on the Cloudbreak Dashboard.

To create a new cluster with embedded LDAP support follow these steps:

  1. Fill out the `Configure Cluster` tab with appropriate values
  2. Open the `Setup Network and Security` tab
     1. Select a `Network` and a `Security Group` that fit for your needs
     2. Check the `Start LDAP And Configure SSSD`
  3. `Choose Blueprint`...etc.

In the background **Cloudbreak creates a default SSSD configuration named `cloudbreak-default-ldap`**. If there is no
other selected configuration, it **starts LDAP service then integrate them**.

If you want to **connect to an Ambari node** (except Ambari server), just use `ambari-qa` user with `cloudbreak`
password to login:
```
ssh ambari-qa@[ambari-host] -p 2022
```

# SSSD configurations via CLI

## Manage SSSD configurations

You can provide all of your configuration parameters one-by-one via `add` command or you can `upload` in a configuration file.

**Add SSSD configuration**
```
sssdconfig add --name [config-name] --providerType [LDAP|ACTIVE_DIRECTORY|IPA] --url [provider-url] --schema [AD|IPA|RFC2307|RFC2307BIS] --baseSearch [search-base-of-posix-entities] --tlsReqcert [NEVER|ALLOW|TRY|DEMAND|HARD]
```
Explanation of the parameters:

- `--name` the name of the new security configuration
    - Starts with a lowercase alphabetic
    - Can contain lowercase alphanumeric and hyphens only
    - Number of characters should be between 1 and 100
- `--providerType`
    - `LDAP` Lightweight Directory Access Protocol
    - `ACTIVE_DIRECTORY` Active Directory
    - `IPA` Identity, Policy and Audit suit
- `--url` your LDAP or AD provider address
    - Can contain LDAP and AD protocols only
    - Number of characters should be between 10 and 255
- `--schema` The schema defines all the objects and attributes that the service uses to implementation,
  store data.
    - `RFC2307`
    - `RFC2307BIS`
    - `IPA`
    - `AD`
- `--baseSearch` your base search string for your Users and Groups
    - Number of characters should be between 10 and 255
- `--tlsReqcert` applied Transport Layer Security

Optional parameters and theirs explanation:

- `--description` [string] a maximum 1000 character long description for the new configuration
- `--adServer` [string] IP address or Host name of the used Active Directory server.
    - In case of more than one server, the list should be comma-separated
- `--kerberosServer` [string] IP address or Host names of the Kerberos server.
    - In case of more than one server, the list should be comma-separated
- `--kerberosRealm` [string] name of your Kerberos Realm
- `--publicInAccount` [flag] If it is checked, all the users belonging to your account will be able to use this
security configuration, but cannot delete it

**Upload SSSD configuration**
```
sssdconfig upload --name [config-name] --file [configuration-path]
```
Optional parameters and theirs explanation:

- `--description` [string] a maximum 1000 character long description for the new configuration
- `--publicInAccount` [flag] If it is checked, all the users belonging to your account will be able to use this
security configuration, but cannot delete it

## Enable SSSD configuration

To create a new cluster with SSSD configuration in Cloudbreak Shell, you **should select one of your SSSD configuration
 before `cluster create`**:
```
sssdconfig select --name sssd-test-config
```
or
```
sssdconfig select --id 2
```

## Embedded LDAP support

In Cloudbreak there is a built in but optional LDAP service. To create a new cluster with embedded LDAP support in
Cloudbreak Shell, you should **place `ldapRequired` flag in the `cluster create`**:
```
cluster create --ldapRequired
```

In the background **Cloudbreak creates a default SSSD configuration named `cloudbreak-default-ldap`**. If there is no
other selected configuration, it **starts LDAP service then integrate them**.

If you want to **connect to an Ambari node** (except Ambari server), just use `ambari-qa` user with `cloudbreak`
password to login:
```
ssh ambari-qa@[ambari-host] -p 2022
```

# Test SSSD configuration

User and group IDs are starting at 10000 in the LDAP database, so **after login you have to see this results:**

```
[ambari-qa@host ~]$ id ambari-qa
uid=10000(ambari-qa) gid=10000(hadoop) groups=10000(hadoop),100(users)
[ambari-qa@host ~]$ getent passwd ambari-qa
ambari-qa:*:10000:10000:ambari-qa:/home/ambari-qa:/bin/bash
```
# Throubleshooting

In Cloudbreak the SSSD service starts in very verbose mode.

**To read log files:**

- Login to the host as `centos` user
```
ssh centos@[ambari-host] -i [cluster-credential]
```
- Jump into Ambari agent Docker container
```
sudo docker exec -it $(docker ps --format="{{.Names}}" | grep ambari-agent) bash
```
- Logs are found at `/var/log/sssd` directory in file per service format
```
[root@docker-ambari /]# ls /var/log/sssd
ldap_child.log	sssd_LDAP.log  sssd.log  sssd_nss.log  sssd_pam.log
```
