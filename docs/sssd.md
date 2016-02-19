#System Security Services Daemon configuration

> This feature is currently `TECHNICAL PREVIEW`.

By default Cloudbreak installs Hadoop with a few default users. Most of the time default users don't give great freedom, to manage permissions in the ecosystem.
Other big problem around the user management is that created users must be consistent on the whole cluster, otherwise operations will fail.
That's where System Security Services Daemon (a.k.a. SSSD) comes in picture. SSSD is a system daemon. Its primary function is to provide access to identity and authentication remote resource through a common framework that can provide caching and offline support to the system. Cloudbreak helps to install and configure SSSD, and sets up an SSH server on Ambari hosts, to allow log in with external users on the hosts's 2022 port.

```
ssh [external-user]@[ambari-host] -p 2022
```

## Manage SSSD configurations

You can add new configuration on the web UI. Go to **manage security configurations** section and select **create configuration**. There are 3 types of configuration:

 * PARAMETERS, Cloudbreak will generate configuration by the given parameters
 * FILE, upload your configuration
 * TEXT, simply type or paste your configuration

In the shell you have two options `add` and `upload`.

```
sssdconfig add --name [config-name] --providerType [LDAP|ACTIVE_DIRECTORY|IPA] --url [provider-url] --schema [AD|IPA|RFC2307|RFC2307BIS] --baseSearch [search-base-of-posix-entities] --tlsReqcert [NEVER|ALLOW|TRY|DEMAND|HARD]
```

This command has optional parameters:

`--description` "string" description of the configuration

`--adServer` "string" comma-separated list of IP addresses or hostnames of the AD servers

`--kerberosServer` "string" comma-separated list of IP addresses or hostnames of the Kerberos servers

`--kerberosRealm` "string" name of the Kerberos realm

`--publicInAccount` "flag" flags if the configuration is public in the account

To upload configuration please use `upload` command:

```
sssdconfig upload --name [config-name] --file [configuration-path]
```

This command also has optional parameters:

`--description` "string" description of the configuration

`--publicInAccount` "flag" flags if the configuration is public in the account

## Enable SSSD configuration

There are two ways to enable SSSD configuration on a Cloudbreak cluster.

 * On UI in the **Create cluster** wizard, on the **Setup Network and Security** tab, check the **Use pre configured SSSD** option and select an existing configuration at **Select configuration**.
 * In CLoudbreak shell before `cluster create` command select a configuration by name `sssdconfig select --name [config-name]` or by id `sssdconfig select --id [config-id]`

## Embedded LDAP support

In Cloudbreak there is a built in but optionally LDAP service,

 * On UI in the **Create cluster** wizard, on the **Setup Network and Security** tab, check the **Start LDAP and configure SSSD** option.

or

 * In Cloudbreak shell place `ldapRequired` flag in `cluster create` command: `cluster create --ldapRequired`.

That's it. In the background Cloudbreak creates a default SSSD configuration named `cloudbreak-default-ldap` if there is no other selected configuration, starts LDAP service and integrate them together. If you want to connect to an Ambari node (except Ambari server), just use `ambari-qa` user with `cloudbreak` password to login: `ssh ambari-qa@[ambari-host] -p 2022`.

### Test configuration

User and group ids are starting at 10000 in the LDAP database, so after login you have to see this results:

```
[ambari-qa@host ~]$ id ambari-qa
uid=10000(ambari-qa) gid=10000(hadoop) groups=10000(hadoop),100(users)
[ambari-qa@host ~]$ getent passwd ambari-qa
ambari-qa:*:10000:10000:ambari-qa:/home/ambari-qa:/bin/bash
```

## Throubleshooting

In Cloudbreak the SSSD service starts in very verbose mode. To read log files first login to the host as `centos` user.

```
ssh centos@[ambari-host] -i [cluster-credential]
```

Next you have jump into Ambari agent Docker container.

```
sudo docker exec -it $(docker ps --format="{{.Names}}" | grep ambari-agent) bash
```

Logs are found at `/var/log/sssd` directory in file per service format.

```
[root@docker-ambari /]# ls /var/log/sssd
ldap_child.log	sssd_LDAP.log  sssd.log  sssd_nss.log  sssd_pam.log
```
