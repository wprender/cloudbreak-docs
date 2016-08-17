# Ambari Database

Ambari by default uses an embedded database to persist data. Ambari and Cloudbreak don't take care on database backups, so this should be a good solution for example ephemeral or test clusters, but not for long running production clusters. Ability to configure remote database for Ambari in Cloudbreak comes in picture here. You should setup a supported database on your own way or use cloud provider's database service and simply pass details to Cloudbreak during cluster creation. Cloudbreak would configure Ambari to connect that remote database. Out of the box PostgreSQL, MariaDB and MySQL are supported. That means if you are using these type of databases you only need to take care on the database itself and the user permissions to create the cluster. Cloudbreak will initialize database tables, relations, default values and downloads JDBC driver too for Ambari. On other case you have to execute create SQL on your database and deliver JDBC driver to `/opt/jdbc-drivers` directory on Ambari server node.

## Good to Know

- Cloudbreak doesn't validate database connection itself, so wrong connection parameters cause cluster installation fail.
- Database must be available for Ambari server. The concrete solution is depends on many things for example network topology.
    - Be sure the database is located in the same region than Ambari cluster. Slow database connection also causes cluster installation fail.
    - Your own database could be on a public server with firewall protection, but for security reason we suggest to use private virtual network with subnet and configure Cloudbreak network to use existing resources.
- If you selected PostgreSQL, Ambari shall use the `public` schema, not possible to configure different one.
- Database name, username and password should not contain ' character. Other special characters are allowed by Cloudbreak.
- On case of out of the box supported databases Cloudbreak creates the tables and Ambari upgrades if neccessary, but all other operations on the database is your responsibility.

## Configure database on the web UI

You should find database configuration under ***Advanced options*** on ***Configure Ambari Database*** tab.

![](/images/ambari-database.png)
<sub>*Full size [here](/images/ambari-database.png).*</sub>

## Configure database with shell

To configure remote database for Ambari with Cloudbreak shell you have to use `database configure` command before `cluster create` command:

```
database configure --vendor [vendor] --host [host-or-ip] --port [port] --name [database-name] --username [user-name] --password [password]
```

Vendor values are:

- MARIADB
- MSSQL
- MYSQL
- ORACLE
- POSTGRES
- SQLANYWHERE

### Upgrade JDBC driver

During installation Cloudbreak distributes JDBC driver for Ambari to different locations. If you want to upgrade or use different one you have to do the steps manually:

- copy driver to `/var/lib/ambari-server/jdbc-drivers` directory
- symlink driver to `/usr/share/java`, `/usr/lib/jvm/java/jre/lib/ext` directories
- reconfigure Ambari by executing `ambari-server setup --jdbc-db=[db-vendor] --jdbc-driver=[driver-location]` command

